# Author - Neha Sharma  
**GitHub Username**: `NehaSharma1795`  

## ✅ Complete CI/CD Pipeline Check

1. **Source Code Repo** (GitHub)  
2. **CI - Build/Test** (GitHub Actions)  
3. **Docker Image Build**  
4. **Docker Image Push to ECR**  
5. **CD - Auto Deploy to EKS** (ArgoCD via GitOps)  
6. **Infrastructure Provisioning** (VPC, Subnets etc.) — *Manually described, can be Terraform-ized*  
7. **TLS/SSL Security** via ALB  
8. **Secrets Management** — *Partially, GitHub Secrets only*  
9. **Kubernetes YAML Manifests** — Described via ArgoCD apps  
10. **Observability (Logging + Monitoring)** via CloudWatch + Grafana  
11. **Security** — WAF, Shield, SG, RBAC, etc.  
12. ⚠️ **Alerts/Notifications** — ❌ Not covered (Missing CloudWatch Alarms or SNS)  
13. ♻️ **Auto Scaling** for Frontend/Backend  

---

## 🌐 AWS EKS-Based Full-Stack Application Architecture

### Tech Stack

- **Frontend**: Node.js  
- **Backend**: FastAPI  
- **Database**: PostgreSQL (AWS RDS)  
- **CI/CD**: GitHub Actions + ArgoCD  
- **Container Registry**: Amazon ECR  
- **Infrastructure**: AWS VPC, EKS, ALB, RDS  
- **Monitoring**: CloudWatch, Prometheus, Grafana  
- **Security**: WAF, Shield, GuardDuty, RBAC, Network Policies  

---

### Infrastructure Setup

- Create a VPC with CIDR block (e.g., 10.0.0.0/16)  
- Create Public Subnets (for ALB, Bastion, frontend)  
- Create Private Subnets (for backend, database, EKS worker nodes)  
- Attach Internet Gateway for public access  
- Configure NAT Gateway for private subnet outbound internet  
- Setup Route Tables (public and private)  
- Configure Security Groups (Frontend-SG, Backend-SG, Database-SG)  

---

### CI/CD Process

- Push code to GitHub  
- GitHub Actions builds Docker image  
- Push Docker image to Amazon ECR  
- ArgoCD running inside EKS syncs repo  
- ArgoCD deploys updated version to EKS cluster  

---

### Kubernetes Deployment

- Deploy ArgoCD to EKS  
- Create ArgoCD Application YAML pointing to GitHub repo  
- ArgoCD syncs and deploys frontend and backend services using Kubernetes manifests  

---

### Database Setup

- Create PostgreSQL database using Amazon RDS  
- Deploy in private subnet  
- Allow inbound traffic only from backend via security group  
- Disable public access  
- Enable backups and monitoring  

---

### Load Balancer Setup

- Create an Application Load Balancer (ALB)  
- Configure listeners for HTTP (80) and HTTPS (443)  
- Use SSL certificate for HTTPS  
- Create target groups for frontend and backend  
- Route traffic to appropriate services  

---

### Monitoring and Logging

- Install and configure CloudWatch agent on EC2 instances  
- Install Prometheus and Grafana via Helm on EKS  
- Forward logs and metrics  
- Access Grafana dashboards for real-time monitoring  

---

### Security Enhancements

- Use HTTPS for all communication via ALB  
- Setup AWS WAF rules (SQL Injection, XSS, Rate limiting)  
- Enable AWS GuardDuty for threat detection  
- Use AWS Shield for DDoS protection  
- Apply Kubernetes RBAC and Network Policies for internal cluster security  

---

### Optional Enhancements (Not in Base Setup)

- Use AWS Secrets Manager for managing secrets securely  
- Configure CloudWatch Alarms + SNS for alerts  
- Automate infrastructure setup using Terraform or AWS CDK  
- Use Argo Rollouts or Flagger for blue/green or canary deployments  

---

## 🔐 Security Highlights in This Architecture

1. VPC Isolation (public and private subnets)  
2. Security Groups and IAM Roles  
3. SSL/TLS Termination at the Application Load Balancer (ALB)  
4. AWS WAF + Shield Protection  
5. Database is Placed in a Private Subnet  
6. EKS RBAC and Kubernetes Network Policies  
7. CI/CD Secured with GitHub Secrets  
8. Docker Image Scanning on Push (using ECR)  
9. Monitoring via CloudWatch + Prometheus + Grafana  

---

**✅ This architecture includes many security-related features that make it a highly secured, production-ready deployment.**
