#!/bin/bash

region=cn-hongkong

# stop instance
if [[ -f instance.id ]]; then
    instance_id=$(cat instance.id)
    aliyun ecs StopInstance --region ${region} --InstanceId ${instance_id}
    echo "ECS instance stopped ..."
    sleep 30
    # aliyun ecs DescribeInstances --RegionId cn-hongkong  | jq -r .Instances.Instance[].Status
    # must be 'Stopped'

    # destroy instance
    aliyun ecs DeleteInstance --region ${region} --InstanceId ${instance_id}
    echo "ECS instance deleted ..."
    sleep 10
else
    echo "No instance ID present"
fi

# delete security group
if [[ -f securitygroup.id ]]; then
    sec_grp_id=$(cat securitygroup.id)
    aliyun ecs DeleteSecurityGroup --region ${region} --SecurityGroupId ${sec_grp_id}
    echo "security group deleted"
    sleep 5
else
    echo "No security group ID present"
fi

# delete vSwitch
if [[ -f vswitch.id ]]; then
    vswitch_id=$(cat vswitch.id)
    aliyun vpc DeleteVSwitch --region ${region} --RegionId ${region} --VSwitchId ${vswitch_id}
    echo "vSwitch deleted"
    sleep 5
else
    echo "No vSwitch ID present"
fi

# delete VPC
if [[ -f vpc.id ]]; then
    vpc_id=$(cat vpc.id)
    aliyun vpc DeleteVpc --region ${region} --RegionId ${region} --VpcId ${vpc_id}
    echo "VPC deleted"
else
    echo "No VPC ID present"
fi
