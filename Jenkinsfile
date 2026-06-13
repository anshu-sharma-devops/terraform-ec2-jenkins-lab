pipeline {
    agent { label 'agent-1' }

    environment {
        AWS_REGION = 'ap-south-1'
        REPO_URL   = 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
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
                withCredentials([
                    string(credentialsId: '6ed56b40-ef1d-495b-9e6f-d6658effcde0', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: '82ee2094-7f7e-4fb5-beac-69e2dbc7c0f9', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo 'Initializing Terraform...'
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform init
                    '''
                }
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
                withCredentials([
                    string(credentialsId: '6ed56b40-ef1d-495b-9e6f-d6658effcde0', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: '82ee2094-7f7e-4fb5-beac-69e2dbc7c0f9', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo 'Running Terraform Plan...'
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform plan
                    '''
                }
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
                withCredentials([
                    string(credentialsId: '6ed56b40-ef1d-495b-9e6f-d6658effcde0', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: '82ee2094-7f7e-4fb5-beac-69e2dbc7c0f9', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo 'Applying Terraform changes...'
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Post Actions') {
            steps {
                withCredentials([
                    string(credentialsId: '6ed56b40-ef1d-495b-9e6f-d6658effcde0', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: '82ee2094-7f7e-4fb5-beac-69e2dbc7c0f9', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo 'Terraform apply complete!'
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        terraform output
                    '''
                }
            }
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
