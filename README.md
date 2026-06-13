# 🚀 Terraform + AWS + Jenkins + Ansible + Docker CI/CD Lab

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=for-the-badge&logo=amazonaws)
![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=for-the-badge&logo=jenkins)
![Ansible](https://img.shields.io/badge/Config-Ansible-EE0000?style=for-the-badge&logo=ansible)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker)
![Linux](https://img.shields.io/badge/OS-Ubuntu-E95420?style=for-the-badge&logo=ubuntu)
![GitHub](https://img.shields.io/badge/SCM-GitHub-181717?style=for-the-badge&logo=github)

---

## 📖 Project Overview

A production-style DevOps lab demonstrating end-to-end CI/CD automation using **GitHub**, **Jenkins**, **Terraform**, **Ansible**, and **Docker** on AWS EC2.

The pipeline is triggered automatically on every GitHub push. Jenkins orchestrates the full workflow — provisioning infrastructure with Terraform, configuring servers with Ansible, and building/deploying Docker containers — without manual intervention.

This project was built through real-world DevOps practice including infrastructure failures, EC2 recovery, Terraform state management, SSH debugging, and full environment rebuilds from scratch — skills that mirror actual production engineering work.

---

## 🏗 Architecture

```text
Developer (MacBook)
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
(jenkins-agent)
    │
    ├── Terraform Init → Validate → Plan → Approval → Apply
    │       │
    │       ▼
    │   AWS Infrastructure (EC2, Security Groups)
    │
    ├── Ansible Playbook
    │       │
    │       ▼
    │   Install Java + Git + Docker on all EC2s
    │   Install + start Jenkins on Controller
    │   Configure jenkins user on Agent
    │
    └── Docker Pipeline
            │
            ▼
        Build image → Push to Docker Hub (anshu9103) → Deploy container
```

---

## 🎯 What This Project Demonstrates

- **Infrastructure as Code** — provisioning AWS resources with Terraform
- **CI/CD Pipeline Design** — multi-stage Jenkins pipelines with approval gates
- **Configuration Management** — automated server setup with Ansible playbooks
- **Jenkins Controller-Agent Architecture** — distributed build execution over SSH
- **Docker Integration** — containerized application builds and deployments
- **Remote Terraform State** — S3 backend for shared state across environments
- **GitHub Integration** — webhook-triggered automated pipelines
- **AWS Administration** — EC2, Security Groups, Key Pairs, S3, Free Tier management
- **Real-World Troubleshooting** — EC2 failures, SSH KEX timeouts, Terraform state recovery, GPG key issues

---

## 🛠 Technologies Used

| Technology | Purpose |
|------------|---------|
| AWS EC2 | Cloud compute instances |
| AWS S3 | Remote Terraform state backend |
| Terraform | Infrastructure provisioning (IaC) |
| Jenkins | CI/CD orchestration |
| Ansible | Server configuration management |
| Docker | Application containerization |
| Docker Hub | Container image registry (anshu9103) |
| Ubuntu 24.04 LTS | Operating system |
| GitHub | Source control + webhook trigger |
| SSH | Secure Controller-Agent communication |
| Java OpenJDK 21 | Jenkins runtime |

---

## 📁 Repository Structure

```
terraform-ec2-jenkins-lab/
├── main.tf                          # Jenkins Controller EC2 + Security Group + S3 backend
├── agent.tf                         # Jenkins Agent EC2 + Security Group
├── variables.tf                     # Input variables (region, instance type, key)
├── outputs.tf                       # Public IPs, private IPs, instance IDs
├── Jenkinsfile                      # Full CI/CD pipeline definition
├── ansible/
│   ├── ansible.cfg                  # Ansible configuration
│   ├── inventory/
│   │   └── aws_ec2.yml              # Dynamic EC2 inventory (amazon.aws plugin)
│   └── playbooks/
│       └── configure_server.yml    # Full server configuration playbook
├── screenshots/                     # Project screenshots
└── README.md
```

---

## ⚙️ Prerequisites

Before starting, make sure you have:

- AWS account with IAM user and programmatic access keys
- AWS CLI configured (`aws configure`)
- Terraform installed (`terraform --version`)
- Ansible installed (`ansible --version`)
- Python boto3/botocore (`pip install boto3 botocore`)
- Ansible AWS collection (`ansible-galaxy collection install amazon.aws`)
- SSH key pair `.pem` file available locally
- Docker Hub account

---

## 🚀 Quick Start — Full Environment Setup

### Step 1 — Clone the Repository

```bash
git clone https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab.git
cd terraform-ec2-jenkins-lab
```

### Step 2 — Import Your SSH Key to AWS

```bash
ssh-keygen -y -f ~/Downloads/jenkins-key.pem > ~/Downloads/jenkins-key.pub

aws ec2 import-key-pair \
  --key-name "jenkins-key" \
  --public-key-material fileb://~/Downloads/jenkins-key.pub \
  --region ap-south-1
```

### Step 3 — Create S3 Bucket for Terraform State

```bash
aws s3 mb s3://jenkins-terraform-state-anshu --region ap-south-1
```

### Step 4 — Provision EC2 Instances with Terraform

```bash
terraform init
terraform plan
terraform apply
```

Terraform provisions:
- `terraform-jenkins-server` — Jenkins Controller (ports 22, 8080)
- `jenkins-agent` — Jenkins Agent (port 22)
- Security Groups for both instances

Note the output IPs:
```bash
terraform output
# agent_private_ip  = "172.31.x.x"
# agent_public_ip   = "x.x.x.x"
# jenkins_public_ip = "x.x.x.x"
```

### Step 5 — Configure All Servers with Ansible

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
  -i ansible/inventory/aws_ec2.yml \
  ansible/playbooks/configure_server.yml \
  --private-key ~/Downloads/jenkins-key.pem \
  -u ubuntu
```

Ansible automatically installs on **both instances**: Java 21, Git, Docker

On **Controller only**: Jenkins (installed, enabled, started) + prints initial password

On **Agent only**: jenkins user created with SSH directory + added to docker group

### Step 6 — Access Jenkins

```
http://<CONTROLLER_PUBLIC_IP>:8080
```

Get initial password (printed by Ansible, or manually):
```bash
ssh -i ~/Downloads/jenkins-key.pem ubuntu@<CONTROLLER_PUBLIC_IP> \
  "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

---

## 🔗 Jenkins Setup

### Add Credentials

```
Manage Jenkins → Credentials → System → Global → Add Credentials
```

| ID | Kind | Description |
|----|------|-------------|
| `AWS_ACCESS_KEY_ID` | Secret text | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | Secret text | AWS Secret Key |
| `jenkins-agent-key` | SSH Username with private key | Agent SSH key (username: ubuntu) |
| `dockerhub-credentials` | Username with password | Docker Hub credentials |

> ⚠️ When creating credentials, make sure to type the ID in the **ID field**, not the Description field.
> Verify credential IDs via: Manage Jenkins → Script Console:
> ```groovy
> import com.cloudbees.plugins.credentials.CredentialsProvider
> import jenkins.model.Jenkins
> def creds = CredentialsProvider.lookupCredentials(
>     com.cloudbees.plugins.credentials.common.StandardCredentials,
>     Jenkins.instance, null, null)
> creds.each { c -> println "ID: ${c.id} | Description: ${c.description}" }
> ```

### Add Jenkins Agent Node

```
Manage Jenkins → Nodes → New Node
```

| Field | Value |
|-------|-------|
| Node Name | `agent-1` |
| Type | Permanent Agent |
| Remote root directory | `/home/ubuntu` |
| Labels | `agent-1` |
| Launch method | Launch agents via SSH |
| Host | Agent Private IP |
| Credentials | jenkins-agent-key |
| Host Key Verification | Non-verifying Verification Strategy |

### Set Built-in Node Executors to 0

```
Manage Jenkins → Nodes → Built-In Node → Configure
Number of executors: 0
```

---

## 🔄 CI/CD Pipeline — Terraform

### Pipeline Stages

```text
GitHub push → webhook
    ↓
Stage 1: Checkout SCM — clone repo
    ↓
Stage 2: Terraform Init — initialize S3 backend + providers
    ↓
Stage 3: Terraform Validate — syntax check
    ↓
Stage 4: Terraform Plan — preview changes
    ↓
Stage 5: Manual Approval Gate — human review
    ↓
Stage 6: Terraform Apply — provision infrastructure
    ↓
Stage 7: Post Actions — show terraform output
    ↓
Pipeline Success ✅
```

### Jenkinsfile

```groovy
pipeline {
    agent { label 'agent-1' }

    environment {
        AWS_REGION            = 'ap-south-1'
        REPO_URL              = 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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
        success { echo '✅ Pipeline completed successfully!' }
        failure { echo '❌ Pipeline failed. Check stage logs for details.' }
    }
}
```

---

## 🐳 Docker Pipeline — Build, Push & Deploy

### Docker Flow

```text
Jenkins Agent EC2
    │
    ├── Clone repo (contains Dockerfile)
    │
    ├── docker build -t anshu9103/flask-app:latest .
    │
    ├── docker login (Docker Hub credentials from Jenkins)
    │
    ├── docker push anshu9103/flask-app:latest
    │
    └── docker run -d -p 5000:5000 anshu9103/flask-app:latest
            │
            ▼
        App running on Agent EC2 port 5000
```

### Docker Hub Setup

1. Go to [https://hub.docker.com](https://hub.docker.com)
2. Account Settings → Security → New Access Token
3. Name: `jenkins-access` | Permissions: Read & Write
4. Copy token → add to Jenkins as `dockerhub-credentials`

### Docker Jenkinsfile (docker-pipeline)

```groovy
pipeline {
    agent { label 'agent-1' }

    environment {
        DOCKER_IMAGE = 'anshu9103/flask-app'
        DOCKER_TAG   = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/anshu-sharma-devops/terraform-ec2-jenkins-lab'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo 'Deploying Docker container...'
                sh '''
                    docker stop flask-app || true
                    docker rm flask-app || true
                    docker run -d \
                        --name flask-app \
                        -p 5000:5000 \
                        ${DOCKER_IMAGE}:latest
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'docker ps | grep flask-app'
                echo "App running at http://<AGENT_PUBLIC_IP>:5000"
            }
        }
    }

    post {
        success { echo '✅ Docker pipeline completed. Container deployed!' }
        failure {
            sh 'docker stop flask-app || true'
            echo '❌ Pipeline failed. Container stopped.'
        }
    }
}
```

---

## 📦 Ansible Configuration

### ansible.cfg

```ini
[defaults]
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/Downloads/jenkins-key.pem
deprecation_warnings = False
```

### Dynamic Inventory (aws_ec2.yml)

```yaml
plugin: amazon.aws.aws_ec2
regions:
  - ap-south-1
filters:
  instance-state-name: running
keyed_groups:
  - key: tags.Name
    prefix: name
hostnames:
  - ip-address
compose:
  ansible_host: public_ip_address
```

### What the Playbook Installs

**Play 1 — All instances:**
- Java 21, Git, Docker (with GPG key + repository)
- Docker service enabled and started
- ubuntu user added to docker group

**Play 2 — Controller only:**
- Jenkins GPG key (2026) + apt repository
- Jenkins installed, enabled, started
- jenkins user added to docker group
- Initial admin password printed

**Play 3 — Agent only:**
- jenkins user created with home directory
- `.ssh` directory with correct permissions
- jenkins user added to docker group

---

## 🗄 Remote Terraform State (S3 Backend)

Terraform state is stored in S3 so both local Mac and Jenkins Agent share the same state — preventing duplicate resource creation errors.

```hcl
terraform {
  backend "s3" {
    bucket = "jenkins-terraform-state-anshu"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
```

Migrate existing local state to S3:
```bash
terraform init -migrate-state
```

---

## 🔥 Real-World Incidents & How They Were Solved

### Incident 1 — Jenkins Agent SSH KEX Timeout
**Symptom:** `The kexTimeout (65000 ms) expired` — agent offline, builds hanging at Validate stage for 9+ minutes.

**Root Cause:** Jenkins Agent EC2 OS hung. SSH handshake never completed on both public and private IPs.

**Fix:**
```
AWS Console → EC2 → Agent → Instance State → Stop → Start
Jenkins → Nodes → Agent → Update IP → Relaunch Agent
```

**Prevention:** Use Elastic IP on agent so IP never changes on reboot.

---

### Incident 2 — EC2 Instance Not Startable
**Symptom:** `The instance is not in a state from which it can be started`

**Root Cause:** EC2 instance was permanently terminated (hardware failure).

**Fix:**
```bash
terraform state rm aws_instance.jenkins_agent
terraform apply -target=aws_instance.jenkins_agent
```

---

### Incident 3 — Terraform Key Pair Not Found
**Symptom:** `InvalidKeyPair.NotFound: The key pair 'healthcare-key' does not exist`

**Root Cause:** Key pair name in Terraform (`healthcare-key`) didn't exist in AWS.

**Fix:**
```bash
ssh-keygen -y -f ~/Downloads/jenkins-key.pem > ~/Downloads/jenkins-key.pub
aws ec2 import-key-pair \
  --key-name "jenkins-key" \
  --public-key-material fileb://~/Downloads/jenkins-key.pub \
  --region ap-south-1
```
Then update all `.tf` files: `key_name = "jenkins-key"`

---

### Incident 4 — Conflicting Docker APT Repository
**Symptom:** `Conflicting values set for option Signed-By` — apt update failing on both EC2s.

**Root Cause:** Two Docker repo files existed (`docker.list` and `download_docker_com_linux_ubuntu.list`) with different GPG key references.

**Fix:**
```bash
ssh ubuntu@<EC2_IP> "sudo rm -f \
  /etc/apt/sources.list.d/docker.list \
  /etc/apt/sources.list.d/download_docker_com_linux_ubuntu.list \
  && sudo apt update"
```

---

### Incident 5 — Jenkins GPG Key Expired
**Symptom:** `NO_PUBKEY 7198F4B714ABFC68` — Jenkins apt repository not trusted.

**Root Cause:** Ansible playbook used `jenkins.io-2023.key` which had expired.

**Fix:** Update key URL in Ansible playbook:
```yaml
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key | \
gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
```

---

### Incident 6 — Terraform Duplicate Security Groups
**Symptom:** `InvalidGroup.Duplicate: The security group already exists`

**Root Cause:** Jenkins Agent ran `terraform apply` with empty local state — tried to create security groups that already existed in AWS.

**Fix:** Migrated to S3 backend so all environments share same state:
```bash
aws s3 mb s3://jenkins-terraform-state-anshu --region ap-south-1
terraform init -migrate-state
```

---

### Incident 7 — Jenkins Credential ID Mismatch
**Symptom:** `Could not find credentials entry with ID 'AWS_ACCESS_KEY_ID'`

**Root Cause:** Credential value was entered in Description field instead of ID field — resulting in auto-generated UUID IDs.

**Diagnosis via Jenkins Script Console:**
```groovy
import com.cloudbees.plugins.credentials.CredentialsProvider
import jenkins.model.Jenkins
def creds = CredentialsProvider.lookupCredentials(
    com.cloudbees.plugins.credentials.common.StandardCredentials,
    Jenkins.instance, null, null)
creds.each { c -> println "ID: ${c.id} | Description: ${c.description}" }
```
**Fix:** Deleted and recreated credentials with correct IDs. Then moved to `environment` block in Jenkinsfile for cleaner credential injection.

---

## ✅ Project Outcome

Successfully built a production-style CI/CD environment where:

- A **GitHub push** automatically triggers a Jenkins pipeline
- **Terraform** provisions AWS infrastructure running on the Jenkins Agent with **S3 remote state**
- **Ansible** configures all deployed servers automatically (Java, Git, Docker, Jenkins)
- **Docker** is installed on all EC2s and integrated into Jenkins pipelines
- **Docker Hub** stores built images accessible from anywhere
- A **manual approval gate** prevents unreviewed infrastructure changes
- **7 real production incidents** were diagnosed and resolved

---

## 📚 Skills Demonstrated

| Category | Skills |
|----------|--------|
| IaC | Terraform, AWS provider, S3 backend, state import, state recovery |
| CI/CD | Jenkins pipelines, Jenkinsfile, approval gates, credential management |
| Config Mgmt | Ansible playbooks, dynamic EC2 inventory, idempotent tasks, GPG keys |
| Containers | Docker install, Dockerfile, Docker Hub, image build/push/deploy |
| Cloud | AWS EC2, Security Groups, Key Pairs, S3, IAM, Free Tier |
| Linux | Ubuntu, SSH, systemd, apt, file permissions, user management |
| DevOps | Incident response, troubleshooting, recovery, Git, real-world debugging |

---

## 🔄 AWS Account Migration & Lessons Learned

During this project, the original AWS account became unavailable. The entire infrastructure was rebuilt in a new AWS Free Tier account — providing real-world experience with infrastructure recovery.

**Challenges Solved:**
- Terraform state out of sync → `terraform state rm` + reimport
- EC2 key pair not found → import existing key to AWS
- Free Tier instance type changed → `t2.micro` → `t3.micro`
- Security groups already existed → migrated to S3 backend

**Key Lesson — Always use remote Terraform state:**
```hcl
terraform {
  backend "s3" {
    bucket = "your-tfstate-bucket"
    key    = "jenkins-lab/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

---

## 👨‍💻 Author

**Anshu Sharma** — Aspiring Cloud & DevOps Engineer

GitHub: [https://github.com/anshu-sharma-devops](https://github.com/anshu-sharma-devops)
Docker Hub: [https://hub.docker.com/u/anshu9103](https://hub.docker.com/u/anshu9103)