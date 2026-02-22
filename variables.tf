variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-agent"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
  
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 5
    error_message = "Instance count must be between 1 and 5."
  }
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default = {
    Owner = "DevOps Team"
  }
}
