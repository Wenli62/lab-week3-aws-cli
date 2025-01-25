#!/usr/bin/env bash

set -eu

# Source the infrastructure data file
source ./infrastructure_data

region="us-west-2"

# 1. Delete the route to the internet from the route table
aws ec2 delete-route --route-table-id $route_table_id --destination-cidr-block 0.0.0.0/0 --region $region

# 2. Disassociate the route table from the subnet
aws ec2 disassociate-route-table --association-id $(aws ec2 describe-route-tables \
  --filters Name=route-table-id,Values=$route_table_id \
  --query 'RouteTables[0].Associations[0].RouteTableAssociationId' --output text --region $region) --region $region

# 3. Delete the route table
aws ec2 delete-route-table --route-table-id $route_table_id --region $region

# 4. Detach the internet gateway from the VPC
aws ec2 detach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id --region $region

# 5. Delete the internet gateway
aws ec2 delete-internet-gateway --internet-gateway-id $igw_id --region $region

# 6. Delete the subnet
aws ec2 delete-subnet --subnet-id $subnet_id --region $region

# 7. Delete the VPC
aws ec2 delete-vpc --vpc-id $vpc_id --region $region

echo "All resources have been successfully deleted."
