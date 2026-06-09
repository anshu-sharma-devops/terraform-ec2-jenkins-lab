# 🚀 Terraform + AWS + Jenkins Controller-Agent Lab

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge\&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=for-the-badge\&logo=amazonaws)
![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=for-the-badge\&logo=jenkins)
![Linux](https://img.shields.io/badge/OS-Ubuntu-E95420?style=for-the-badge\&logo=ubuntu)

---

# 📖 Project Overview

This project demonstrates how to provision AWS infrastructure using Terraform, install Jenkins on an EC2 instance, configure a Jenkins Agent Node on a separate EC2 instance, and execute pipelines remotely through the Jenkins Controller-Agent architecture.

The objective was to understand Infrastructure as Code (IaC), Jenkins administration, remote build execution, GitHub integration, and Terraform automation.

---

# 🏗 Architecture

```text
Terraform
    │
    ▼
AWS EC2 (Jenkins Controller)
    │
    │ SSH
    ▼
AWS EC2 (Jenkins Agent)
    │
    ▼
Jenkins Pipeline
    │
    ▼
GitHub Repository
```

---

# 🎯 Objectives

* Provision AWS EC2 instances using Terraform
* Configure Security Groups
* Install Jenkins on EC2
* Create and manage Jenkins Jobs
* Configure Jenkins Agent Node
* Connect Controller and Agent using SSH
* Execute pipelines on remote agents
* Integrate GitHub repositories
* Execute Terraform commands through Jenkins

---

# 🛠 Technologies Used

* AWS EC2
* Terraform
* Jenkins
* Ubuntu Linux
* Git
* GitHub
* SSH
* Java (OpenJDK 21)

---

# ⚙️ Implementation Steps

## 1. Provision Jenkins Controller

Using Terraform:

* Created Security Group
* Opened ports 22 and 8080
* Created EC2 instance
* Configured SSH access

## 2. Install Jenkins

```bash
sudo apt update
sudo apt install openjdk-21-jre -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Verified Jenkins service:

```bash
sudo systemctl status jenkins
```

---

## 3. Access Jenkins

```text
http://<public-ip>:8080
```

Retrieved initial password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## 4. Create Jenkins Agent

Provisioned a second EC2 instance using Terraform.

Installed Java:

```bash
sudo apt install openjdk-21-jre -y
```

---

## 5. Configure Jenkins Node

Jenkins Dashboard:

```text
Manage Jenkins
→ Nodes
→ New Node
```

Configured:

* Permanent Agent
* SSH Launch Method
* Ubuntu User
* SSH Private Key Authentication

Successfully connected:

```text
Agent successfully connected and online
```

---

## 6. Execute Pipeline on Agent

Pipeline Example:

```groovy
pipeline {
    agent {
        label 'agent-1'
    }

    stages {
        stage('Verify Agent') {
            steps {
                sh '''
                hostname
                whoami
                pwd
                java --version
                '''
            }
        }
    }
}
```

Result:

```text
Running on Jenkins Agent
Java Installed
Pipeline Success
```

---

## 7. GitHub Integration

Connected Jenkins Pipeline to GitHub repository.

Pipeline performed:

* Clone repository
* Validate repository contents
* Execute Terraform commands

---

## 8. Terraform Pipeline

```groovy
pipeline {
    agent {
        label 'agent-1'
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
    }
}
```

---

# 📚 Key Learnings

* Infrastructure as Code using Terraform
* AWS EC2 provisioning
* Security Group management
* Jenkins installation and configuration
* Jenkins Controller-Agent architecture
* SSH-based node communication
* GitHub integration
* Pipeline automation
* Remote build execution


# 🔄 AWS Account Migration & Infrastructure Recovery

During this project, the original AWS account became unavailable, requiring the entire infrastructure to be migrated and rebuilt in a new AWS Free Tier account.

## Challenges Encountered

### 1. AWS Account Migration

* Configured a new AWS account
* Reconfigured AWS CLI credentials
* Verified account access using:

```bash
aws sts get-caller-identity
```

### 2. Terraform State Recovery

Terraform detected resources that existed in the state file but no longer existed in AWS.

Example:

```text
Terraform detected the following changes made outside of Terraform
aws_instance.jenkins_server has been deleted
aws_security_group.jenkins_sg has been deleted
```

Learned how Terraform state and real infrastructure can become out of sync and how Terraform recreates missing resources.

### 3. EC2 Key Pair Troubleshooting

Encountered:

```text
InvalidKeyPair.NotFound
```

Root Cause:

* Terraform configuration referenced an old key pair from the previous AWS account.

Resolution:

* Created a new EC2 Key Pair named:

```text
jenkins-key
```

* Updated Terraform configuration files:

```hcl
key_name = "jenkins-key"
```

### 4. Free Tier Compatibility Issues

Encountered:

```text
The specified instance type is not eligible for Free Tier
```

Root Cause:

* Original project used:

```text
t2.micro
```

* New AWS account Free Tier eligibility had changed.

Verified eligible instance types using:

```bash
aws ec2 describe-instance-types \
--filters Name=free-tier-eligible,Values=true \
--region ap-south-1
```

Updated Terraform configuration to use:

```hcl
instance_type = "t3.micro"
```

### 5. Infrastructure Recreation

Successfully recreated:

* Jenkins Controller
* Jenkins Agent
* Security Groups
* SSH Access
* Terraform State

Terraform Outputs:

```text
Jenkins Controller Public IP
Jenkins Agent Public IP
Instance IDs
Private IP Addresses
```

### 6. GitHub Repository Maintenance

Updated Terraform codebase and synchronized project configuration with the new AWS environment.

This process provided hands-on experience with:

* AWS Account Migration
* Terraform State Management
* Infrastructure Recovery
* Free Tier Troubleshooting
* EC2 Key Pair Management
* Git Version Control
* Real-world DevOps Troubleshooting

```

## 🚀 Additional DevOps Learning Outcome

One of the most valuable lessons from this project was learning how to troubleshoot and recover infrastructure failures instead of only deploying new resources. Rebuilding the environment from scratch strengthened practical knowledge of Terraform, AWS, Jenkins, Linux, Git, and cloud troubleshooting workflows used by DevOps engineers in production environments.
```

---

# ✅ Project Outcome

Successfully built a production-style Jenkins Controller-Agent environment on AWS using Terraform and Ubuntu Linux.

The Jenkins Controller manages jobs while build execution is delegated to a dedicated Jenkins Agent node, demonstrating a scalable CI/CD architecture used in real-world DevOps environments.

---

# 👨‍💻 Author

**Anshu Sharma**

Aspiring Cloud & DevOps Engineer

GitHub: https://github.com/anshu-sharma-devops
