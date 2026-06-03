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

---

# ✅ Project Outcome

Successfully built a production-style Jenkins Controller-Agent environment on AWS using Terraform and Ubuntu Linux.

The Jenkins Controller manages jobs while build execution is delegated to a dedicated Jenkins Agent node, demonstrating a scalable CI/CD architecture used in real-world DevOps environments.

---

# 👨‍💻 Author

**Anshu Sharma**

Aspiring Cloud & DevOps Engineer

GitHub: https://github.com/anshu-sharma-devops
