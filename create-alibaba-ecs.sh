#!/bin/bash

# Configure the AccessKey ID and AccessKey secret used by Alibaba Cloud CLI.
# Note: Make sure that the AccessKey ID and AccessKey secret are securely
# configured by configuring environment variables or by using a configuration
# file.

#InstanceType=ecs.e-c1m1.large
InstanceType=ecs.xn4.small

set -e

region=cn-hongkong
#region=cn-hangzhou

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
aliyun ecs AuthorizeSecurityGroup --RegionId ${region} --SecurityGroupId ${SecurityGroupId} --IpProtocol tcp --SourceCidrIp 0.0.0.0/0 --PortRange 22/22 >/dev/null 2>&1

PASSWORD=$(openssl rand -base64 20)
echo
echo ${PASSWORD} >ecs-password

# 4. Run the command used to create an ECS instance.
echo "Creating an ECS instance..."
INSTANCE_ID_RAW=$(aliyun ecs RunInstances \
    --RegionId ${region} \
    --ImageId ubuntu_22_04_x64_20G_alibase_20240508.vhd \
    --InstanceType ${InstanceType} \
    --SecurityGroupId ${SecurityGroupId} \
    --VSwitchId ${VSwitchId} \
    --InstanceName ${INSTANCE_NAME} \
    --InstanceChargeType PostPaid \
    --InternetMaxBandwidthOut 50 \
    --Password $PASSWORD \
    --SystemDisk.Category cloud_efficiency \
    --SystemDisk.Size 40)

# 5. Obtain the InstanceId parameter for subsequently returned information.
INSTANCE_ID=$(echo "$INSTANCE_ID_RAW" | jq -r '.InstanceIdSets.InstanceIdSet[]')
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

echo "You can now connect via ssh to root@${ip_address} next ..."
set +e
