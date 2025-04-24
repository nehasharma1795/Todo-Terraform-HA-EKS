Author - Neha Sharma
Git UserName -NehaSharma1795

** Complete CI/CD Pipeline Check **

1️⃣	Source Code Repo (GitHub)	
2️⃣	CI - Build/Test (GitHub Actions)
3️⃣	Docker Image Build	
4️⃣	Docker Image Push to ECR	
5️⃣	CD - Auto Deploy to EKS	by (ArgoCD via GitOps)
6️⃣	Infrastructure Provisioning (VPC, Subnets etc.)	by Manually Described (Can be Terraform-ized)
7️⃣	TLS/SSL Security by via ALB
8️⃣	Secrets Management	but Partially (GitHub Secrets only)
9️⃣	Kubernetes YAML Manifests	 Described via ArgoCD apps
🔟	Observability (Logging + Monitoring) by (CloudWatch + Grafana)
🔐	Security (WAF, Shield, SG, RBAC, etc.)	
⚠️	Alerts/Notifications	❌ Not covered (Missing CloudWatch Alarms or SNS)
♻️	Auto Scaling for Frontend/Backend

**AWS EKS-Based Full-Stack Application Architecture **
**1. Tech Stack**
1.1 Frontend: Node.js
1.2 Backend: FastAPI
1.3 Database: PostgreSQL (AWS RDS)
1.4 CI/CD: GitHub Actions + ArgoCD
1.5 Container Registry: Amazon ECR
1.6 Infrastructure: AWS VPC, EKS, ALB, RDS
1.7 Monitoring: CloudWatch, Prometheus, Grafana
1.8 Security: WAF, Shield, GuardDuty, RBAC, Network Policies

**2. Infrastructure Setup**
2.1 Create a VPC with CIDR block (e.g., 10.0.0.0/16)
2.2 Create Public Subnets (for ALB, Bastion, frontend)
2.3 Create Private Subnets (for backend, database, EKS worker nodes)
2.4 Attach Internet Gateway for public access
2.5 Configure NAT Gateway for private subnet outbound internet
2.6 Setup Route Tables (public and private)
2.7 Configure Security Groups (Frontend-SG, Backend-SG, Database-SG)

**3. CI/CD Process**
3.1 Push code to GitHub
3.2 GitHub Actions builds Docker image
3.3 Push Docker image to Amazon ECR
3.4 ArgoCD running inside EKS syncs repo
3.5 ArgoCD deploys updated version to EKS cluster

**4. Kubernetes Deployment**
4.1 Deploy ArgoCD to EKS
4.2 Create ArgoCD Application YAML pointing to GitHub repo
4.3 ArgoCD syncs and deploys frontend and backend services using Kubernetes manifests

**5. Database Setup**
5.1 Create PostgreSQL database using Amazon RDS
5.2 Deploy in private subnet
5.3 Allow inbound traffic only from backend via security group
5.4 Disable public access
5.5 Enable backups and monitoring

**6. Load Balancer Setup**
6.1 Create an Application Load Balancer (ALB)
6.2 Configure listeners for HTTP (80) and HTTPS (443)
6.3 Use SSL certificate for HTTPS
6.4 Create target groups for frontend and backend
6.5 Route traffic to appropriate services

**7. Monitoring and Logging**
7.1 Install and configure CloudWatch agent on EC2 instances
7.2 Install Prometheus and Grafana via Helm on EKS
7.3 Forward logs and metrics
7.4 Access Grafana dashboards for real-time monitoring

**8. Security Enhancements**
8.1 Use HTTPS for all communication via ALB
8.2 Setup AWS WAF rules (SQL Injection, XSS, Rate limiting)
8.3 Enable AWS GuardDuty for threat detection
8.4 Use AWS Shield for DDoS protection
8.5 Apply Kubernetes RBAC and Network Policies for internal cluster security

**9. Optional Enhancements (Not in Base Setup)**
9.1 Use AWS Secrets Manager for managing secrets securely
9.2 Configure CloudWatch Alarms + SNS for alerts
9.3 Automate infrastructure setup using Terraform or AWS CDK
9.4 Use Argo Rollouts or Flagger for blue/green or canary deployments



**This architecture includes many security-related features that make it a highly secured, production-ready deployment.**

1. VPC Isolation (public and private subnets)
2. Security Groups and IAM Roles
3. SSL/TLS Termination at the Application Load Balancer (ALB)
4. AWS WAF + Shield Protection
5. Database is Placed in a Private Subnet
6. EKS RBAC and Kubernetes Network Policies
7. CI/CD Secured with GitHub Secrets
8. Docker Image Scanning on Push (using ECR)
9. Monitoring via CloudWatch + Prometheus + Grafana
