# CloudFormation VPC Template

This project provides an AWS CloudFormation template to deploy a basic Virtual Private Cloud (VPC) infrastructure with public and private subnets, Internet Gateway, NAT Gateways, and associated route tables. It's designed for DevOps practices and can serve as a foundation for deploying applications in AWS.

## Overview

The CloudFormation template (`CloudFormation.yaml`) creates the following resources:

- **VPC**: A virtual private cloud with DNS support enabled
- **Internet Gateway**: For public internet access
- **2 Public Subnets**: Across two availability zones, with auto-assigned public IPs
- **2 Private Subnets**: Across two availability zones, for internal resources
- **NAT Gateways**: For outbound internet access from private subnets
- **Route Tables**: Public and private route tables with appropriate routes
- **Route Table Associations**: Linking subnets to their respective route tables

## Architecture

```
VPC (10.0.0.0/16)
├── Public Subnet 1 (10.0.0.0/24) - AZ1
├── Public Subnet 2 (10.0.1.0/24) - AZ2
├── Private Subnet 1 (10.0.2.0/24) - AZ1
├── Private Subnet 2 (10.0.3.0/24) - AZ2
├── Internet Gateway
├── NAT Gateway 1 (for Private Subnet 1)
└── NAT Gateway 2 (for Private Subnet 2)
```

## Prerequisites

Before deploying this template, ensure you have:

1. **AWS Account**: An active AWS account with appropriate permissions
2. **AWS CLI**: Installed and configured with your credentials
   ```bash
   aws configure
   ```
3. **Permissions**: Your AWS user/role should have permissions to create CloudFormation stacks, VPC resources, and NAT Gateways
4. **Region**: Choose a region that supports NAT Gateways (most regions do)

## Parameters

The template accepts the following parameter:

- **VpcCidr** (String): CIDR block for the VPC
  - Default: `10.0.0.0/16`
  - Description: The IP address range for your VPC

## Deployment

### Option 1: Using the Provided Scripts

This project includes bash scripts for easy deployment:

1. **Create Stack**:
   ```bash
   ./create.sh
   ```

2. **Update Stack**:
   ```bash
   ./update.sh
   ```

Before running the scripts, edit the variables at the top of each file:
- `STACK_NAME`: Your desired stack name
- `REGION`: AWS region (e.g., `us-east-1`)
- `PARAMETERS`: Adjust parameter values if needed

### Option 2: Manual AWS CLI Commands

#### Create Stack
```bash
aws cloudformation create-stack \
  --stack-name my-vpc-stack \
  --template-body file://CloudFormation.yaml \
  --parameters ParameterKey=VpcCidr,ParameterValue=10.0.0.0/16 \
  --region us-east-1 \
  --capabilities CAPABILITY_IAM
```

#### Update Stack
```bash
aws cloudformation update-stack \
  --stack-name my-vpc-stack \
  --template-body file://CloudFormation.yaml \
  --parameters ParameterKey=VpcCidr,ParameterValue=10.0.0.0/16 \
  --region us-east-1 \
  --capabilities CAPABILITY_IAM
```

### Option 3: AWS Console

1. Go to AWS CloudFormation Console
2. Click "Create Stack"
3. Upload `CloudFormation.yaml`
4. Provide stack name and parameters
5. Review and create

## Monitoring Deployment

After initiating stack creation/update, monitor the progress:

```bash
# Check stack status
aws cloudformation describe-stacks --stack-name my-vpc-stack --region us-east-1

# View stack events
aws cloudformation describe-stack-events --stack-name my-vpc-stack --region us-east-1
```

## Outputs

The stack provides outputs for key resource IDs (assuming the template has outputs - check the YAML for details).

## Cost Considerations

This template creates resources that incur costs:

- **NAT Gateway**: ~$0.045/hour per NAT Gateway (2 created)
- **Data Transfer**: Costs for data processed through NAT Gateways
- **VPC Endpoints**: No additional cost for basic VPC resources

Estimate costs using the AWS Pricing Calculator.

## Security Best Practices

- The template follows least-privilege principles
- Private subnets are isolated from direct internet access
- Public subnets have internet access through IGW
- Consider adding security groups and NACLs for additional security

## Customization

To customize the template:

1. **Add More Subnets**: Duplicate subnet resources and adjust CIDR blocks
2. **Add Resources**: Include EC2 instances, RDS databases, etc.
3. **Modify Parameters**: Add more parameters for flexibility
4. **Tags**: Update tags for better resource management

## Troubleshooting

### Common Issues

1. **Insufficient Permissions**: Ensure your AWS user has CloudFormation and VPC permissions
2. **CIDR Conflicts**: Check for overlapping CIDR blocks with existing VPCs
3. **Availability Zones**: Ensure the region has at least 2 AZs
4. **NAT Gateway Limits**: Check your NAT Gateway limits per AZ

### Stack Deletion

To delete the stack:

```bash
aws cloudformation delete-stack --stack-name my-vpc-stack --region us-east-1
```

**Warning**: This will delete all resources created by the stack. Ensure no dependent resources exist.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Test thoroughly
5. Submit a pull request

## Support

For issues or questions:
- Check AWS CloudFormation documentation
- Review AWS CLI error messages
- Ensure all prerequisites are met
