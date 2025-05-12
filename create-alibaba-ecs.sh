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
#region=cn-hangzhou

# Check availablity
t=/tmp/availability.json
aliyun ecs DescribeAvailableResource --DestinationResource InstanceType --RegionId ${region} >$t
instance_type=/tmp/instance_type.txt
cat $t | jq -r '.AvailableZones.AvailableZone[0].AvailableResources.AvailableResource[0].SupportedResources.SupportedResource[] | select(.Status == "Available" and (.Value | startswith("ecs.t6-") and endswith(".large"))) | .Value' >${instance_type}

if ! grep -q "ecs." ${instance_type}; then
    echo "No instances available"
    exit 1
fi

InstanceType=$(head -n1 ${instance_type})

# 1. Configure variables.
INSTANCE_NAME="ecs_cli_demo"

#3. Create a Virtual Private Cloud (VPC), a vSwitch, and a security group.
echo "Creating a VPC..."
VpcId=$(aliyun vpc CreateVpc --RegionId ${region} --CidrBlock 192.168.0.0/16 | jq -r .VpcId)
echo "VPC ID is ${VpcId}"
echo ${VpcId} >vpc.id

printf "Wait status is 'available' ... "
aliyun vpc DescribeVpcAttribute --RegionId ${region} --VpcId ${VpcId} --waiter expr='Status' to=Available
echo "done"

echo "Creating a vSwitch..."
VSwitchId=$(aliyun vpc CreateVSwitch --CidrBlock 192.168.0.0/24 --VpcId ${VpcId} --ZoneId=${region}-d | jq -r .VSwitchId)
echo ${VSwitchId} >vswitch.id

echo "Creating a security group..."
SecurityGroupId=$(aliyun ecs CreateSecurityGroup --RegionId ${region} --VpcId ${VpcId} | jq -r .SecurityGroupId)
echo ${SecurityGroupId} >securitygroup.id
aliyun ecs AuthorizeSecurityGroup \
    --RegionId ${region} \
    --SecurityGroupId ${SecurityGroupId} \
    --IpProtocol tcp \
    --SourceCidrIp 0.0.0.0/0 \
    --PortRange 22/22

PASSWORD=$(openssl rand -base64 20)
echo
echo ${PASSWORD} >ecs-password

# 4. Run the command used to create an ECS instance.
echo "Creating an ECS instance..."
t=/tmp/instance_id.raw
aliyun ecs RunInstances \
    --RegionId ${region} \
    --ImageId ubuntu_22_04_x64_20G_alibase_20240508.vhd \
    --InstanceType ${InstanceType} \
    --SecurityGroupId ${SecurityGroupId} \
    --VSwitchId ${VSwitchId} \
    --InstanceName ${INSTANCE_NAME} \
    --InstanceChargeType PostPaid \
    --InternetMaxBandwidthOut 50 \
    --Password $PASSWORD \
    --SystemDisk.Category cloud_essd \
    --SystemDisk.Size 40 \
    >$t

jq . $t

# 5. Obtain the InstanceId parameter for subsequently returned information.
INSTANCE_ID=$(jq -r '.InstanceIdSets.InstanceIdSet[]' $t)
echo ${INSTANCE_ID} >instance.id

# 6. Wait for 20 seconds for the ECS instance to be created.
echo "Waiting for the ECS instance to be created..."
for i in $(seq 1 20); do
    printf "."
    sleep 1
done
echo

# 7. Query the status of the ECS instance.
echo "Querying the status of the ECS instance..."
INSTANCE_ID_QUOTED=$(printf '"%s"' "$INSTANCE_ID")
aliyun ecs DescribeInstances \
    --RegionId ${region} \
    --InstanceIds "[${INSTANCE_ID_QUOTED}]" \
    --output cols=InstanceId,InstanceName,InstanceType,ImageId,Status,PublicIpAddress.IpAddress[0] \
    rows=Instances.Instance[]

ip_address=$(aliyun ecs DescribeInstances \
    --RegionId ${region} \
    --InstanceIds "[${INSTANCE_ID_QUOTED}]" |
    jq -r .Instances.Instance[0].PublicIpAddress.IpAddress[0])

cat <<EOM >inventory.yaml
---
hk:
  hosts:
    hk01:
      ansible_host: ${ip_address}
      ansible_user: root
      ansible_port: 22
      ansible_password: ${PASSWORD}
EOM

echo "You can now connect via ssh to root@${ip_address} next ... or via ansiblle-playbook -i inventory.yaml"

set +e
