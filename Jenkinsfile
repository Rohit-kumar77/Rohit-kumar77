pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "us-east-2"
  }

  stages {
    stage('Set AWS Credentials') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-credentials', 
          usernameVariable: 'AWS_ACCESS_KEY_ID', 
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          echo "AWS credentials loaded"
        }
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init \
            -backend-config="bucket=my-terraform-state-bucket87" \
            -backend-config="key=env/dev/terraform.tfstate" \
            -backend-config="region=us-east-2"
        '''
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -var-file="terraform.tfvars"'
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: 'Approve Terraform apply?'
        sh 'terraform apply -var-file="terraform.tfvars" -auto-approve'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/*.tfstate*', allowEmptyArchive: true
    }
  }
}
