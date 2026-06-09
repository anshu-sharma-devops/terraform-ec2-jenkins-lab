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

        stage('Terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Approval') {
            steps {
                input message: 'Terraform plan ready. Approve to apply infrastructure changes?'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform changes...'
                sh 'terraform apply tfplan'
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Running Ansible playbook...'
                sh '''
                    cd ansible
                    ansible-playbook -i inventory/aws_ec2.yml \
                        playbooks/configure_server.yml \
                        --private-key ~/.ssh/jenkins-key.pem \
                        -u ubuntu
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed. Infrastructure provisioned and configured.'
        }
        failure {
            echo 'Pipeline failed. Check stage logs above for details.'
        }
        always {
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
    }
}
