#!/bin/bash
declare -a hosts=("OT-Linux-PLC" "OT-Linux-HMI" "IT-Linux-PC-1" "IT-Win-Share" "IT-Win-PC-1" "OT-Win-PC-1")

for host in "${hosts[@]}"
do
    terraform destroy -target openstack_compute_instance_v2.$host -auto-approve
done

terraform apply

