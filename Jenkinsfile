pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "us-east-2"
  }

  stages {
    stage('Terraform Pipeline') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'aws-credentials', 
          usernameVariable: 'AWS_ACCESS_KEY_ID', 
          passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
          script {
            sh '''
              terraform init \
                -backend-config="bucket=my-terraform-state-bucket87" \
                -backend-config="key=env/dev/terraform.tfstate" \
                -backend-config="region=us-east-2"

              terraform validate

              terraform plan -var-file="terraform.tfvars"

              terraform apply -var-file="terraform.tfvars" -auto-approve
            '''
          }
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**/*.tfstate*', allowEmptyArchive: true
    }
  }
}
