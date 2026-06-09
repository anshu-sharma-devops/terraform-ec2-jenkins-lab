pipeline {
    agent { label 'agent-1' }

    environment {
        AWS_REGION = 'ap-south-1'
        REPO_URL   = 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repository from GitHub...'
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                sh 'terraform validate'
            }
        }
    }
}