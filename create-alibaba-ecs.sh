#!/bin/bash

# Configure the AccessKey ID and AccessKey secret used by Alibaba Cloud CLI.
# Note: Make sure that the AccessKey ID and AccessKey secret are securely
# configured by configuring environment variables or by using a configuration
# file.

# Instance Overview:
# https://www.alibabacloud.com/help/en/ecs/user-guide/overview-of-instance-families?spm=a3c0i.28098073.8707792030..544da1472HjYkH#g8y
#
set -e

region=cn-hongkong
# region=cn-hangzhou

# === SSH Key Setup ===
# You can either:
#   a) Use an existing key pair name in Alibaba Cloud (set KEY_PAIR_NAME), OR
#   b) Generate a new local SSH key and import it (default behavior below)

KEY_PAIR_NAME="ecs-cli-key-$(date +%s)"
LOCAL_SSH_KEY_PATH="$HOME/.ssh/id_alibaba_ecs"

if [[ ! -f "${LOCAL_SSH_KEY_PATH}" ]]; then
    echo "Generating new SSH key at ${LOCAL_SSH_KEY_PATH}..."
    #ssh-keygen -t rsa -b 2048 -f "${LOCAL_SSH_KEY_PATH}" -N "" -C "alibaba-ecs-cli"
    ssh-keygen -t ed25519 -f "${LOCAL_SSH_KEY_PATH}" -N "" -C "alibaba-ecs-cli"
fi

# Import public key into Alibaba Cloud if not already present
echo "Importing SSH public key to Alibaba Cloud as key pair: ${KEY_PAIR_NAME}..."
aliyun ecs ImportKeyPair \
    --RegionId "${region}" \
    --KeyPairName "${KEY_PAIR_NAME}" \
    --PublicKeyBody "$(cat ${LOCAL_SSH_KEY_PATH}.pub)"

# === Instance Type Selection ===
t=/tmp/availability.json
aliyun ecs DescribeAvailableResource --DestinationResource InstanceType --RegionId "${region}" >"$t"
instance_type=/tmp/instance_type.txt

if [[ "$1" != "" ]]; then
    echo "I try to take instance type $1 ..."

    cat "$t" | jq -r '.AvailableZones.AvailableZone[0].AvailableResources.AvailableResource[0].SupportedResources.SupportedResource[] | select(.Status == "Available") | .Value' >"${instance_type}"

    if ! grep -q "$1" "${instance_type}"; then
        echo "No instances available"
        exit 1
    fi

    echo "Good news, instance type $1 is available"
    InstanceType="$1"
else
    cat "$t" | jq -r '.AvailableZones.AvailableZone[0].AvailableResources.AvailableResource[0].SupportedResources.SupportedResource[] | select(.Status == "Available" and (.Value | startswith("ecs.t6-") and endswith(".large"))) | .Value' >"${instance_type}"

    if ! grep -q "ecs." "${instance_type}"; then
        echo "No instances available"
        exit 1
    fi

    InstanceType=$(head -n1 "${instance_type}")
    echo "I choose instance type ${InstanceType}"
fi
echo

# === Network Setup ===
INSTANCE_NAME="ecs_cli_demo"

echo "Creating a VPC..."
VpcId=$(aliyun vpc CreateVpc --RegionId "${region}" --CidrBlock 192.168.0.0/16 | jq -r .VpcId)
echo "VPC ID is ${VpcId}"
echo "${VpcId}" >vpc.id

printf "Wait status is 'available' ... "
aliyun vpc DescribeVpcAttribute --RegionId "${region}" --VpcId "${VpcId}" --waiter expr='Status' to=Available
echo "done"

echo "Creating a vSwitch..."
VSwitchId=$(aliyun vpc CreateVSwitch --CidrBlock 192.168.0.0/24 --VpcId "${VpcId}" --ZoneId="${region}-d" | jq -r .VSwitchId)
echo "${VSwitchId}" >vswitch.id

echo "Creating a security group..."
SecurityGroupId=$(aliyun ecs CreateSecurityGroup --RegionId "${region}" --VpcId "${VpcId}" | jq -r .SecurityGroupId)
echo "${SecurityGroupId}" >securitygroup.id
aliyun ecs AuthorizeSecurityGroup \
    --RegionId "${region}" \
    --SecurityGroupId "${SecurityGroupId}" \
    --IpProtocol tcp \
    --SourceCidrIp 0.0.0.0/0 \
    --PortRange 22/22

# === Launch Instance with SSH Key ===
echo "Creating an ECS instance with SSH key pair: ${KEY_PAIR_NAME}..."
t=/tmp/instance_id.raw
aliyun ecs RunInstances \
    --RegionId "${region}" \
    --ImageId ubuntu_22_04_x64_20G_alibase_20240508.vhd \
    --InstanceType "${InstanceType}" \
    --SecurityGroupId "${SecurityGroupId}" \
    --VSwitchId "${VSwitchId}" \
    --InstanceName "${INSTANCE_NAME}" \
    --InstanceChargeType PostPaid \
    --InternetMaxBandwidthOut 50 \
    --KeyPairName "${KEY_PAIR_NAME}" \
    --SystemDisk.Category cloud_essd \
    --SystemDisk.Size 40 \
    >"$t"

jq . "$t"

INSTANCE_ID=$(jq -r '.InstanceIdSets.InstanceIdSet[]' "$t")
echo "${INSTANCE_ID}" >instance.id

echo "Waiting for the ECS instance to be created..."
for i in $(seq 1 20); do
    printf "."
    sleep 1
done
echo

# === Get Public IP ===
echo "Querying the status of the ECS instance..."
INSTANCE_ID_QUOTED=$(printf '"%s"' "$INSTANCE_ID")
aliyun ecs DescribeInstances \
    --RegionId "${region}" \
    --InstanceIds "[${INSTANCE_ID_QUOTED}]" \
    --output cols=InstanceId,InstanceName,InstanceType,ImageId,Status,PublicIpAddress.IpAddress[0] \
    rows=Instances.Instance[]

ip_address=$(aliyun ecs DescribeInstances \
    --RegionId "${region}" \
    --InstanceIds "[${INSTANCE_ID_QUOTED}]" |
    jq -r '.Instances.Instance[0].PublicIpAddress.IpAddress[0]')

# === Generate Ansible Inventory (SSH) ===
cat <<EOM >inventory.yaml
---
hk:
  hosts:
    hk01:
      ansible_host: ${ip_address}
      ansible_user: root
      ansible_port: 22
      ansible_ssh_private_key_file: ${LOCAL_SSH_KEY_PATH}
EOM

# === Optional: SSH config helper ===
cat <<EOM >ssh-config.txt
Host hk01
  HostName ${ip_address}
  User root
  IdentityFile ${LOCAL_SSH_KEY_PATH}
  IdentitiesOnly yes
  StrictHostKeyChecking no
EOM

echo
echo "✅ Instance created successfully!"
echo "Public IP: ${ip_address}"
echo "SSH Key: ${LOCAL_SSH_KEY_PATH}"
echo
echo "You can now connect via:"
echo "  ssh -i ${LOCAL_SSH_KEY_PATH} root@${ip_address}"
echo
echo "Or with Ansible:"
echo "  ansible-playbook -i inventory.yaml your-playbook.yml"
echo
echo "SSH config snippet saved to ssh-config.txt (add to ~/.ssh/config if desired)."
