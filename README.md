# Automated Spring Boot Deployment with Terraform and AWS EC2

## **Description**
This project automates the deployment of a Spring Boot application using Terraform to provision AWS infrastructure. It eliminates manual intervention, ensuring a streamlined and consistent deployment process.

### **Technologies Used**
- **AWS EC2**: Provisioned instances to host the Spring Boot application.
- **Terraform**: Automated the creation of AWS resources, including VPC, subnets, security groups, and EC2 instances.
- **Spring Boot**: Packaged and deployed the application on AWS EC2.
- **Maven**: Built the application and managed dependencies.
- **Bash**: Automated tasks such as cloning repositories, managing builds, and application execution.

## **Key Features**
- **Infrastructure as Code (IaC)**: Used Terraform to define and provision AWS resources.
- **Application Deployment**: Automated build and deployment of a Spring Boot application.
- **Networking Configuration**: Configured VPC, subnets, and security groups to ensure secure and accessible application deployment.
- **Clean Build Environment**: Ensured the deletion of the `target` directory during the build process for consistency.
- **Monitoring**: Captured application logs for easier debugging and performance tracking.

## **Setup Instructions**

### **1. Prerequisites**
- **AWS Account**: Ensure you have access to an AWS account.
- **AWS CLI**: Installed and configured on your machine. Follow the [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
- **Terraform**: Installed on your system. Follow the [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- **SSH Key Pair**: To enable secure access to EC2 instances.


### **2. Generate an SSH Key Pair**
Run the following command to generate an SSH key pair:
```bash
ssh-keygen -t rsa -b 4096 -f my-key.pem
```
This will create:
- `my-key.pem`: Private key file (keep it secure).
- `my-key.pem.pub`: Public key file.

Place these files in the project directory. Do not commit them to the repository for security reasons.



### **3. Configure AWS CLI**
Set up AWS credentials using the following command:
```bash
aws configure
```
Provide your:
- Access Key ID
- Secret Access Key
- Default Region (e.g., `us-east-1`)
- Default Output Format (e.g., `json`)

You can create an AWS API token in the [AWS IAM Console](https://console.aws.amazon.com/iam/) if you don't have one.


### **4. Update Variables**
Edit the `variables.tf` file to configure project-specific settings:
- `aws_region`: AWS region for deployment.
- `key_name`: Name of the SSH key pair (e.g., `my-key`).
- `public_key_file`: Path to the `.pub` file (e.g., `my-key.pem.pub`).
- `git_repo_url`: URL of the Git repository containing the Spring Boot application.


### **5. Deploy the Infrastructure**
Run the following commands to deploy the infrastructure:
```bash
terraform init
terraform plan
terraform apply
```
Confirm the prompt to deploy the resources. or can give the command terraform apply -auto-approve


### **6. Access the Application**
Once deployment is complete, the public IP of the EC2 instance will be displayed in the terminal. Use it to access the application:
```bash
http://<public-ip>:8080
```
Note: It might take upto 2-3 minutes as the installations would go on in the background


### **Notes**
Note: SSH access to instance isn't possible just with attaching the Key-Pair because:
1. SSH access to the EC2 instance requires proper VPC configuration:
   - If the VPC had no Internet Gateway (IGW) - Without an IGW, your VPC is completely isolated from the internet. It's like having a house with no door to 
     the outside.
   - And even with an IGW, you need a route table to tell traffic how to get to the internet (0.0.0.0/0) through the IGW. Think of it as having a door but no      pathway to reach it.
   - This is why the full networking stack (IGW + route table + associations) is essential for making your EC2 instance accessible via SSH from the internet,      even if you have the key pair properly configured.
2. Logs for the application are stored on the EC2 instance at `/home/ubuntu/application.log`.

---
