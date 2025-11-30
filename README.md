# Fully Automated AWS WordPress Monitoring Stack  
### Terraform | AWS | Prometheus | Grafana | EC2 | RDS

![Terraform](https://img.shields.io/badge/Terraform-AWS%20IaC-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20RDS%20%7C%20VPC-FF9900?logo=amazon-aws&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-Dashboards-F47A20?logo=grafana&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Automation-Complete-success)

---

## 🚀 Overview

This project automates the deployment of a secure, production-ready **WordPress application** with a fully integrated monitoring stack using **Terraform** on AWS.

It provisions:

- EC2 for WordPress
- Amazon RDS (MySQL)
- Prometheus & Node Exporter
- Grafana dashboards
- VPC networking, subnets & security groups

This solves the real-world need for **repeatable, secure infrastructure deployment with observability and zero manual configuration.**

---

## 🏗 Architecture

```mermaid
graph TD;
    User -->|HTTP/HTTPS| ALB;
    ALB --> EC2_WordPress;
    EC2_WordPress --> RDS_MySQL;
    EC2_WordPress --> NodeExporter;
    MonitoringEC2 -->|Scrape Metrics| NodeExporter;
    MonitoringEC2 -->|Scrape AWS CloudWatch via YACE| AWS_CloudWatch;
    MonitoringEC2 --> Prometheus;
    Prometheus --> Grafana;
    Grafana --> User;
```
## 🎯 Key Features

The following features are implemented to ensure security, observability, and ease of deployment:

* **Fully automated AWS deployment using Terraform**
* **Private RDS database** (Deployed in a private subnet, not publicly accessible)
* **Secure networking** with isolated public/private subnets
* **WordPress installed and configured** automatically on launch via User Data
* **Prometheus integration** scrapes EC2, WordPress, and CloudWatch metrics
* **Grafana dashboards** pre-loaded with CPU, memory, RDS, and WP instance metrics
* **Scalable and reusable IaC design** utilizing modular Terraform structures

## 🛠 Tech Stack

| Category | Tools |
| :--- | :--- |
| **IaC** | Terraform |
| **Cloud** | AWS (EC2, RDS, VPC, IAM, Subnets, SGs) |
| **OS** | Amazon Linux 2 |
| **Application** | WordPress (PHP, Apache2) |
| **Monitoring** | Prometheus, Node Exporter, Grafana, YACE |
| **Version Control** | Git & GitHub |

---

## 📁 Repository Structure

```text
📦 wordpress-rds-monitoring
├── main.tf                 # Main configuration entry point
├── variables.tf            # Input variables definition
├── outputs.tf              # Output values (URLs, IPs)
├── modules/                # Reusable Terraform modules
│   ├── network/            # VPC, Subnets, Internet Gateway
│   ├── security/           # Security Groups and Rules
│   ├── rds_mysql/          # RDS instance configuration
│   ├── wordpress_ec2/      # WordPress instance & User Data
│   └── monitoring_ec2/     # Prometheus/Grafana instance
└── README.md               # Project documentation
```
## ⚙ Setup Instructions (Run Locally)

Follow these steps to deploy the infrastructure from your local machine.

---

### 1️⃣ Clone Repository

```bash
git clone https://github.com/githubabhay2003/wordpress-rds-monitoring.git
cd wordpress-rds-monitoring
```
### 2️⃣ Configure AWS Credentials

Make sure your AWS CLI is configured with the correct access key, secret key, and region.

```bash
aws configure
```
AWS CLI reference:
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

### 3️⃣ Initialize Terraform
Run the following commands to initialize Terraform, preview changes, and deploy the infrastructure.
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
Terraform documentation: https://developer.hashicorp.com/terraform/docs/cli
### 4️⃣ Access Outputs

Once the deployment is complete, Terraform will display the following outputs:

- **WordPress Public URL**
- **Prometheus Server URL**
- **Grafana URL**
<img width="1025" height="454" alt="Screenshot 2025-11-28 130057" src="https://github.com/user-attachments/assets/680289f3-41f3-4cee-9b77-3dd039e73e71" />

## 📊 Monitoring Dashboards

| Metric Source | Included |
|--------------|----------|
| Node Exporter | ✅ |
| CloudWatch RDS Metrics (via YACE) | ✅ |
| Custom Grafana Dashboard | ✅ |
| Real-Time Alerts (optional future feature) | ⏳ |

---
## 📷 Preview Screenshots

### 🟢 WordPress Running
<img width="1919" height="903" alt="WordPress Running Screenshot" src="https://github.com/user-attachments/assets/3e3f355d-15da-431a-9fdb-eaa25217eb67" />

---

### 📊 Grafana Dashboard
<img width="1919" height="1021" alt="Grafana Dashboard Screenshot" src="https://github.com/user-attachments/assets/8d77a277-2e61-4c78-8490-6c7d66997e2f" />

---

### 🎯 Prometheus Targets
<img width="1919" height="1020" alt="Prometheus Targets Screenshot" src="https://github.com/user-attachments/assets/c01661c3-abe3-4023-905e-111bc27b67a1" />


---

## 🤝 Contributing

Contributions are welcome.

1. Fork this repository  
2. Create a new feature branch  
3. Submit a pull request  

---

## 📄 License

This project is licensed under the **MIT License**.

MIT License reference:  
https://opensource.org/licenses/MIT

---

## 👤 Author

**Abhay Kumar Saini**

🔹 GitHub: https://github.com/githubabhay2003  
🔹 LinkedIn: https://www.linkedin.com/in/abhay-kumar-saini-571891264/

---

## 🎥 Demo Video


https://github.com/user-attachments/assets/d879b8f7-69a6-44ff-8bc6-2bf076ff51e4





