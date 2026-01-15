#!/bin/bash

# Script to update a CloudFormation stack

STACK_NAME="my-vpc-stack"  # Change this to your desired stack name
TEMPLATE_FILE="CloudFormation.yaml"
REGION="us-east-1"  # Change this to your AWS region

# Parameters (adjust as needed)
PARAMETERS="ParameterKey=VpcCidr,ParameterValue=10.0.0.0/16"

# Update the stack
aws cloudformation update-stack \
  --stack-name $STACK_NAME \
  --template-body file://$TEMPLATE_FILE \
  --parameters $PARAMETERS \
  --region $REGION \
  --capabilities CAPABILITY_IAM  # Add if needed for IAM resources

echo "Stack update initiated. Check AWS Console for status."