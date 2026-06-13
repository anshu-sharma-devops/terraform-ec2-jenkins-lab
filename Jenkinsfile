pipeline {
    agent { label 'agent-1' }

    environment {
        AWS_REGION             = 'ap-south-1'
        REPO_URL               = 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
        AWS_ACCESS_KEY_ID      = credentials('6ed56b40-ef1d-495b-9e6f-d6658effcde0')
        AWS_SECRET_ACCESS_KEY  = credentials('82ee2094-7f7e-4fb5-beac-69e2dbc7c0f9')
    }

    stages {

        stage('Checkout SCM') {
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

        stage('Terraform Plan') {
            steps {
                echo 'Running Terraform Plan...'
                sh 'terraform plan'
            }
        }

        stage('Approval') {
            steps {
                echo 'Waiting for manual approval...'
                timeout(time: 10, unit: 'MINUTES') {
                    input message: 'Do you want to apply the Terraform changes?', ok: 'Apply'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform changes...'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Post Actions') {
            steps {
                echo 'Terraform apply complete!'
                sh 'terraform output'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs above.'
        }
    }
}