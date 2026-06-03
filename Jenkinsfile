pipeline {
    agent {
        label 'agent-1'
    }

    stages {
        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
    }
}