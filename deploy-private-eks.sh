#!/bin/bash
echo "Enter AWS Region:"
read REGION
echo "Enter Stack Name for SG + Endpoints:"
read SG_STACK
echo "Enter VPC ID:"
read VPC_ID
echo "Enter Private Subnet IDs (comma separated):"
read PRIVATE_SUBNETS
echo "Enter Admin CIDR for Bastion:"
read ADMIN_CIDR

aws cloudformation deploy   --region $REGION   --stack-name $SG_STACK   --template-file sg-endpoints.yaml   --capabilities CAPABILITY_NAMED_IAM   --parameter-overrides VpcId=$VPC_ID PrivateSubnetIds=$PRIVATE_SUBNETS AdminCidr=$ADMIN_CIDR

echo "Do you want to deploy Bastion stack? (y/n)"
read DEPLOY_BASTION
if [ "$DEPLOY_BASTION" == "y" ]; then
  echo "Enter Bastion Stack Name:"
  read BASTION_STACK
  echo "Enter Public Subnet ID:"
  read PUBLIC_SUBNET
  echo "Enter Bastion SG ID:"
  read BASTION_SG_ID

  aws cloudformation deploy     --region $REGION     --stack-name $BASTION_STACK     --template-file bastion.yaml     --capabilities CAPABILITY_NAMED_IAM     --parameter-overrides VpcId=$VPC_ID PublicSubnetId=$PUBLIC_SUBNET BastionSGId=$BASTION_SG_ID
fi

echo "Do you want to deploy CodeBuild stack? (y/n)"
read DEPLOY_CB
if [ "$DEPLOY_CB" == "y" ]; then
  echo "Enter CodeBuild Stack Name:"
  read CB_STACK
  echo "Enter CodeBuild SG ID:"
  read CB_SG_ID
  echo "Enter IAM Role ARN for CodeBuild:"
  read CB_ROLE_ARN

  aws cloudformation deploy     --region $REGION     --stack-name $CB_STACK     --template-file codebuild.yaml     --capabilities CAPABILITY_NAMED_IAM     --parameter-overrides VpcId=$VPC_ID PrivateSubnetIds=$PRIVATE_SUBNETS CodeBuildSGId=$CB_SG_ID ServiceRoleArn=$CB_ROLE_ARN
fi
