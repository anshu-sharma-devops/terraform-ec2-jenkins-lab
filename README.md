# ⚙️ Terraform EC2 Jenkins CI/CD Lab

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=for-the-badge&logo=amazonaws)
![Jenkins](https://img.shields.io/badge/CI-CD-Jenkins-D24939?style=for-the-badge&logo=jenkins)
![Linux](https://img.shields.io/badge/Linux-Server-FCC624?style=for-the-badge&logo=linux)
![GitHub](https://img.shields.io/badge/Version-Control-GitHub-181717?style=for-the-badge&logo=github)

---

## 📌 Project Overview

This project demonstrates a complete **DevOps CI/CD workflow** using Infrastructure as Code.

It provisions an **AWS EC2 instance using Terraform**, installs and configures **Jenkins**, and executes a basic CI pipeline connected with GitHub.

---

## 🧠 Architecture Flow

```text
GitHub Repository
        ↓
Terraform (Infrastructure as Code)
        ↓
AWS EC2 Instance (Ubuntu)
        ↓
Jenkins Installation
        ↓
CI Job Execution
        ↓
Build Output / Logs
