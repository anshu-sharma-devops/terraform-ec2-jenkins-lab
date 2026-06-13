# 🚀 Terraform EC2 Jenkins CI Automation Project

![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=for-the-badge&logo=amazon-aws)
![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=for-the-badge&logo=jenkins)
![Linux](https://img.shields.io/badge/OS-Linux-FCC624?style=for-the-badge&logo=linux)
![GitHub](https://img.shields.io/badge/Version%20Control-GitHub-181717?style=for-the-badge&logo=github)

---

## 🎯 Project Objective

To design and implement a **fully automated CI infrastructure environment** using Infrastructure as Code and CI/CD tools.

This project demonstrates how modern DevOps systems automate:

- Infrastructure provisioning
- Server configuration
- CI tool deployment
- Continuous integration workflow execution

---

## 🧠 High-Level Architecture

```mermaid
flowchart TD

A[Developer / Terraform Code] --> B[Terraform Engine]

B --> C[AWS Cloud Provider]
C --> D[EC2 Instance Provisioned]

D --> E[SSH Access & Configuration Layer]

E --> F[Java Runtime Installation]
F --> G[Jenkins CI Server Setup]

G --> H[Jenkins Dashboard Configuration]
H --> I[CI Job Creation]

I --> J[Build Execution Environment]
J --> K[Linux Command Execution]

K --> L[GitHub Repository Integration]
L --> M[Automated CI Workflow Trigger]

M --> N[Continuous Integration Pipeline Completed Successfully]
