#!/bin/bash

# This script is to take care of missing Ansible module feature to add/remove private network to an instance

# Usage instructions: 
# $1 = instance name
# $2 = network name
# $3 = action (add/remove)

# Example ./private-network-manage.sh $radius $mgmt $add 
# This will attach instance named "radius" to private network "mgmt"

source ~/.vultr.config 

instance=$1
network=$2
action=$3



# Step 1 - Search for the Instance ID
instance_id=`curl -s --location --request GET 'https://api.vultr.com/v2/instances' \
--header "Authorization: Bearer $api_key" | jq -r ' .instances[] | select(.label=="'$instance'" ) | .id'`


# Step 2 - Search for Network ID
network_id=`curl -s --location --request GET 'https://api.vultr.com/v2/private-networks' --header "Authorization: Bearer $api_key" | jq -r ' .networks[] | select(.description=="'$network'" ) | .id'`


# Step 3 -  Act as per the defined action
if [[ $action = "add" ]]
then
    curl  --location --request POST "https://api.vultr.com/v2/instances/$instance_id/private-networks/attach" --data '{"network_id": "'$network_id'"}'  \
    --header "Authorization: Bearer $api_key"

elif [[ $action = "remove" ]]
then
    curl  --location --request POST "https://api.vultr.com/v2/instances/$instance_id/private-networks/detach" --data '{"network_id":"'$network_id'"}' \
    --header "Authorization: Bearer $api_key"

fi
