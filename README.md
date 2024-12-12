Terraform & Ansible Automation for Static Web Application Hosting
Overview
This project automates the deployment of a two-tier static web application in AWS using Terraform and Ansible. The architecture provisions 6 VMs, including web servers, a bastion host, a NAT gateway, and an Application Load Balancer (ALB). Configuration management is handled using Ansible to install and configure Apache HTTP servers on the web servers. GitHub Actions automates the entire process, including security scans, Terraform deployment, and provisioning.

Architecture
VPC & Subnets: Public and private subnets across multiple Availability Zones.
EC2 Instances: 6 VMs; 5 as web servers (2 in public, 3 in private), 1 as bastion host.
ALB: Balances traffic between Webserver 1 & 3.
NAT Gateway: Allows internet access for Webserver 5 in the private subnet.
Ansible: Used to configure web servers (install Apache, ensure service status, apply patches).
GitHub Actions: Automates Terraform workflows and deploys infrastructure.
Project Structure
bash
Copy code
terraform-vpc-project/
├── .github/workflows/terraform.yml       # CI/CD pipeline
├── terraform/                           # Terraform code for infrastructure
├── ansible/                             # Ansible playbooks for configuration
└── README.md
Terraform Workflow
VPC: Creates a VPC with public and private subnets.
EC2 Instances: Launches 6 VMs and configures 5 as web servers.
ALB & Auto Scaling: Configures load balancing and auto-scaling.
Security Groups: Secures the web servers and bastion host.
GitHub Actions Workflow
The GitHub Actions workflow automates the following:

Initialize and validate Terraform configuration.
Run security scans with Checkov and TFLint.
Deploy infrastructure using terraform apply -auto-approve.
Ansible Configuration
Install Apache on web servers.
Configure the servers for static web hosting.
Ensure services are running and apply patches.
How to Use
Clone the repository:
bash
Copy code
git clone https://github.com/<your-github-username>/terraform-vpc-project.git
cd terraform-vpc-project
Set AWS credentials in GitHub Secrets: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION.
Commit and push changes:
bash
Copy code
git add .
git commit -m "Deploy infrastructure"
git push origin main
GitHub Actions will trigger and deploy the infrastructure automatically.
Conclusion
This project automates the deployment and configuration of a static web application using Terraform, Ansible, and GitHub Actions. It ensures secure, scalable infrastructure with continuous integration and deployment.
