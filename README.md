# 🚀 Terraform + AWS + Jenkins + Ansible CI/CD Lab

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=for-the-badge&logo=amazonaws)
![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=for-the-badge&logo=jenkins)
![Ansible](https://img.shields.io/badge/Config-Ansible-EE0000?style=for-the-badge&logo=ansible)
![Linux](https://img.shields.io/badge/OS-Ubuntu-E95420?style=for-the-badge&logo=ubuntu)
![GitHub](https://img.shields.io/badge/SCM-GitHub-181717?style=for-the-badge&logo=github)

---

## 📖 Project Overview

A production-style DevOps lab demonstrating end-to-end CI/CD automation using **GitHub**, **Jenkins**, **Terraform**, and **Ansible** on AWS EC2.

The pipeline is triggered automatically on every GitHub push. Jenkins orchestrates the full workflow — provisioning infrastructure with Terraform and configuring servers with Ansible — without manual intervention.

This project was built to develop real-world DevOps skills including Infrastructure as Code, CI/CD pipeline design, configuration management, Jenkins Controller-Agent architecture, and hands-on cloud troubleshooting.

---

## 🏗 Architecture

```text
Developer
    │
    │  git push
    ▼
GitHub Repository
(anshu-sharma-devops/terraform-ec2-jenkins-lab)
    │
    │  Webhook trigger
    ▼
Jenkins Controller EC2
(terraform-jenkins-server)
    │
    │  SSH — delegates build execution
    ▼
Jenkins Agent EC2
(terraform-agent-server)
    │
    ├── Terraform Init → Validate → Plan → Apply
    │       │
    │       ▼
    │   AWS Infrastructure (EC2, Security Groups)
    │
    └── Ansible Playbook
            │
            ▼
        Configure deployed EC2 instances
```

---

## 🎯 What This Project Demonstrates

- **Infrastructure as Code** — provisioning AWS resources with Terraform
- **CI/CD Pipeline Design** — multi-stage Jenkins pipelines with approval gates
- **Configuration Management** — automated server setup with Ansible playbooks
- **Jenkins Controller-Agent Architecture** — distributed build execution over SSH
- **GitHub Integration** — webhook-triggered automated pipelines
- **AWS Administration** — EC2, Security Groups, Key Pairs, Free Tier management
- **DevOps Troubleshooting** — AWS account migration, Terraform state recovery, EC2 key pair issues

---

## 🛠 Technologies Used

| Technology | Purpose |
|------------|---------|
| AWS EC2 | Cloud compute instances |
| Terraform | Infrastructure provisioning (IaC) |
| Jenkins | CI/CD orchestration |
| Ansible | Server configuration management |
| Ubuntu 24.04 LTS | Operating system |
| GitHub | Source control + webhook trigger |
| SSH | Secure Controller-Agent communication |
| Java OpenJDK 21 | Jenkins runtime |

---

## 📁 Repository Structure

```
terraform-ec2-jenkins-lab/
├── main.tf                          # Jenkins Controller EC2 + Security Group
├── agent.tf                         # Jenkins Agent EC2
├── variables.tf                     # Input variables (region, instance type, key)
├── outputs.tf                       # Public IPs, instance IDs
├── Jenkinsfile                      # Full CI/CD pipeline definition
├── ansible/
│   ├── inventory/
│   │   └── aws_ec2.yml              # Dynamic EC2 inventory
│   └── playbooks/
│       └── configure_server.yml    # Server configuration playbook
├── screenshots/                     # Project screenshots
└── README.md
```

---

## ⚙️ Infrastructure Setup

### 1. Provision EC2 Instances with Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform provisions:
- `terraform-jenkins-server` — Jenkins Controller (port 22, 8080)
- `terraform-agent-server` — Jenkins Agent (port 22)
- Security Groups for both instances

### 2. Install Jenkins on Controller

```bash
sudo apt update
sudo apt install openjdk-21-jre -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Access Jenkins:
```
http://<CONTROLLER_PUBLIC_IP>:8080
```

Retrieve initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### 3. Prepare the Jenkins Agent

```bash
sudo apt update
sudo apt install openjdk-21-jre -y
sudo mkdir -p /home/ubuntu/jenkins-agent
sudo chown ubuntu:ubuntu /home/ubuntu/jenkins-agent
```

---

## 🔗 Jenkins Controller-Agent SSH Setup

### Generate SSH Key on Controller

```bash
sudo su - jenkins
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub   # copy this output
```

### Authorize Controller on Agent

```bash
# On the Agent EC2
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "<JENKINS_PUBLIC_KEY>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Test Connection from Controller

```bash
# As jenkins user on Controller
ssh ubuntu@<AGENT_PRIVATE_IP>
# Type yes when prompted — connection confirmed ✅
```

### Add Node in Jenkins UI

```
Manage Jenkins → Nodes → New Node
```

| Field | Value |
|-------|-------|
| Node Name | `terraform-agent` |
| Type | Permanent Agent |
| Remote root directory | `/home/ubuntu/jenkins-agent` |
| Labels | `agent-1` |
| Launch method | Launch agents via SSH |
| Host | Agent Private IP |
| Credentials | SSH Username with private key (ubuntu) |
| Host Key Verification | Non-verifying Verification Strategy |

---

## 🔄 CI/CD Pipeline — GitHub → Jenkins → Terraform → Ansible

### Pipeline Stages

```text
GitHub push
    ↓  webhook
Stage 1: Checkout — clone repo from GitHub
    ↓
Stage 2: Terraform Init — initialize providers
    ↓
Stage 3: Terraform Validate — check config syntax
    ↓
Stage 4: Terraform Plan — preview infrastructure changes
    ↓
Stage 5: Manual Approval Gate — human review before apply
    ↓
Stage 6: Terraform Apply — provision AWS infrastructure
    ↓
Stage 7: Ansible Deploy — configure provisioned servers
    ↓
Pipeline Success ✅
```

### Jenkinsfile

```groovy
pipeline {
    agent { label 'agent-1' }

    environment {
        AWS_REGION = 'ap-south-1'
        REPO_URL   = 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review Terraform plan. Approve to apply?'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh 'terraform apply tfplan'
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                sh '''
                    ansible-playbook -i ansible/inventory/aws_ec2.yml \
                        ansible/playbooks/configure_server.yml \
                        --private-key ~/.ssh/jenkins-key.pem \
                        -u ubuntu
                '''
            }
        }
    }

    post {
        success { echo '✅ Pipeline completed. Infrastructure provisioned and configured.' }
        failure { echo '❌ Pipeline failed. Check stage logs for details.' }
        always  { archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true }
    }
}
```

---

## 📦 Ansible Configuration

### Install Ansible on Agent

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

### Dynamic Inventory

```yaml
# ansible/inventory/aws_ec2.yml
plugin: amazon.aws.aws_ec2
regions:
  - ap-south-1
filters:
  instance-state-name: running
  tag:Project: jenkins-lab
keyed_groups:
  - key: tags.Role
    prefix: role
```

### Server Configuration Playbook

```yaml
# ansible/playbooks/configure_server.yml
- name: Configure deployed EC2 server
  hosts: all
  become: yes
  tasks:

    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Java
      apt:
        name: openjdk-21-jre
        state: present

    - name: Create app directory
      file:
        path: /opt/app
        state: directory
        owner: ubuntu
        mode: '0755'

    - name: Confirm configuration
      debug:
        msg: "Server {{ inventory_hostname }} configured successfully"
```

---

## 🔄 AWS Account Migration & Lessons Learned

During this project, the original AWS account became unavailable. The entire infrastructure was rebuilt in a new AWS Free Tier account — providing real-world experience with infrastructure recovery.

### Challenges Solved

**Terraform State Out of Sync**
```bash
terraform state rm aws_instance.jenkins_server
terraform state rm aws_security_group.jenkins_sg
terraform apply
```

**EC2 Key Pair Not Found**
```hcl
# Updated Terraform config
key_name = "jenkins-key"
```

**Free Tier Instance Type Changed**
```bash
aws ec2 describe-instance-types \
  --filters Name=free-tier-eligible,Values=true \
  --region ap-south-1
```
Updated from `t2.micro` → `t3.micro`

**Key Lesson — Remote Terraform State prevents this entirely:**
```hcl
terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket"
    key            = "jenkins-lab/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

---

## ✅ Project Outcome

Successfully built a production-style CI/CD environment where:

- A **GitHub push** automatically triggers a Jenkins pipeline
- **Terraform** provisions AWS infrastructure on the Jenkins Agent
- **Ansible** configures the deployed servers automatically
- The **Jenkins Controller-Agent** architecture distributes build execution
- A **manual approval gate** prevents unreviewed infrastructure changes

---

## 📚 Skills Demonstrated

| Category | Skills |
|----------|--------|
| IaC | Terraform, AWS provider, state management |
| CI/CD | Jenkins pipelines, Jenkinsfile, webhooks, approval gates |
| Config Mgmt | Ansible playbooks, dynamic inventory |
| Cloud | AWS EC2, Security Groups, Key Pairs, IAM |
| Linux | Ubuntu, SSH, systemd, file permissions |
| DevOps | Troubleshooting, migration, recovery, Git |

---

## 👨‍💻 Author

**Anshu Sharma** — Aspiring Cloud & DevOps Engineer

GitHub: [https://github.com/anshu-sharma-devops](https://github.com/anshu-sharma-devops)
