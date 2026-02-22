# Terraform AWS Infrastructure

This repository contains Terraform configuration for provisioning AWS infrastructure.

## Project Structure

```
.
├── provider.tf          # Provider configuration and backend setup
├── variables.tf         # Variable definitions
├── outputs.tf          # Output definitions
├── ec2.tf              # EC2 instance and security group resources
├── terraform.tfvars    # Variable values (example)
├── user_data.sh        # EC2 initialization script
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## Prerequisites

- Terraform >= 1.2.0
- AWS CLI configured with appropriate credentials
- AWS account with appropriate permissions

## Getting Started

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Configure Variables

Copy `terraform.tfvars` and customize for your environment:

```bash
cp terraform.tfvars terraform.tfvars.local
# Edit terraform.tfvars.local with your values
```

### 3. Plan Infrastructure

```bash
terraform plan -out=tfplan
```

### 4. Apply Configuration

```bash
terraform apply tfplan
```

### 5. Destroy Infrastructure

```bash
terraform destroy
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | string | `us-west-2` | AWS region |
| `project_name` | string | `terraform-agent` | Project name |
| `environment` | string | `dev` | Environment (dev/staging/prod) |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `instance_count` | number | `1` | Number of instances |
| `instance_name` | string | `ExampleAppServerInstance` | Instance name tag |
| `enable_monitoring` | bool | `false` | Enable detailed monitoring |
| `tags` | map(string) | `{}` | Additional tags |

## Outputs

After applying, you can get outputs using:

```bash
terraform output
terraform output instance_public_ips
```

Key outputs:
- `instance_ids` - IDs of created instances
- `instance_public_ips` - Public IP addresses
- `instance_private_ips` - Private IP addresses
- `security_group_id` - Security group ID

## Remote State (Optional)

To use S3 backend for state management:

1. Create S3 bucket and DynamoDB table for locking
2. Uncomment the `backend "s3"` block in `provider.tf`
3. Update bucket name and region
4. Run `terraform init`

Example S3 setup:

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

## Best Practices

1. **State Management**: Use remote state (S3) for team collaboration
2. **Variables**: Use `.tfvars.local` for sensitive values (not committed)
3. **Validation**: Always run `terraform plan` before `apply`
4. **Naming**: Follow consistent naming conventions
5. **Tags**: Use meaningful tags for cost tracking and organization
6. **Security Groups**: Restrict ingress rules to necessary ports
7. **Version Constraints**: Pin provider versions for consistency

## Troubleshooting

### Provider Authentication
```bash
aws configure
export AWS_PROFILE=your-profile
```

### State Lock Issues
```bash
terraform force-unlock <LOCK_ID>
```

### View Current State
```bash
terraform show
terraform state list
terraform state show aws_instance.app_server
```

## Security Considerations

⚠️ **Important**: 
- Never commit `.tfvars` files with secrets
- Use AWS Secrets Manager or Parameter Store for sensitive data
- Restrict security group rules to specific IPs when possible
- Enable MFA for AWS accounts
- Use IAM roles and policies for EC2 instances
- Enable VPC Flow Logs for network monitoring

## Contributing

1. Create a feature branch
2. Make changes and test locally
3. Run `terraform fmt` to format code
4. Run `terraform validate` to check syntax
5. Submit PR with description of changes

## License

MIT

## Support

For issues or questions, contact the DevOps team.
