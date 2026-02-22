#!/bin/bash
set -e

# Update system packages
yum update -y

# Install common utilities
yum install -y \
  curl \
  wget \
  git \
  vim \
  htop \
  net-tools

# Log initialization
echo "Project: ${project} initialized at $(date)" > /var/log/user-data.log

# Install CloudWatch agent (optional)
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
# rpm -U ./amazon-cloudwatch-agent.rpm

echo "User data script completed successfully"
