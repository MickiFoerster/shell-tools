#!/bin/bash

region=cn-hongkong
instance_id=$(cat instance.id)
sec_grp_id=$(cat securitygroup.id)
vswitch_id=$(cat vswitch.id)
vpc_id=$(cat vpc.id)

# stop instance
aliyun ecs StopInstance --region ${region} --InstanceId ${instance_id}
sleep 30
# aliyun ecs DescribeInstances --RegionId cn-hongkong  | jq -r .Instances.Instance[].Status
# must be 'Stopped'

# destroy instance
aliyun ecs DeleteInstance --region ${region} --InstanceId ${instance_id}
sleep 10
# delete security group
aliyun ecs DeleteSecurityGroup --region ${region} --SecurityGroupId ${sec_grp_id}
sleep 5
# delete vSwitch
aliyun vpc DeleteVSwitch --region ${region} --RegionId ${region} --VSwitchId ${vswitch_id}
sleep 5
# delete VPC
aliyun vpc DeleteVpc --region ${region} --RegionId ${region} --VpcId ${vpc_id}
