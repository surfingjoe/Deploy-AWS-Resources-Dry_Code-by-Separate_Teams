# Modular code - Different teams deploying the same code

## Teams can deploy unique VPC with load balanced Docker containers



### Using Terraform to deploy the infrastructure

The code found here is a part of my blog on using "Infrastructure as Code" with Terraform.  I'm writing different exercises on how to use Terraform to create AWS deployments in my WordPress site. 

## Features
* Using the same modular code to deply AWS resources by the Development team or the Quality_Assuarnce team such that they can deploy in any region with unique AWS characteristics and unique identity tags
* Using Terraform to deploy infrastructure [Why use Infrastructure as Code](https://josephomara.com/2021/08/23/why-infrastructure-as-code/(opens in a new tab))
* use Terraform to deploy an Auto Scaling Group and an Application Load Balancer in AWS
* Load balancing EC2 instances with Docker container for MyWebsite

![Diagram for Simply Modular](/Users/joe/GitHub/Terraform/Simply_modular/Diagram for Simply Modular.jpg)

## Requirements

- Must have an AWS account
- Install AWS CLI, Configure AWS CLI, Install Terraform
- AWS Administrator account or an account with the following permissions:
  - create VPC, subnets, and security groups, internet gateway, NAT instances and routing tables
  - Create. manage, read and write an S3 bucket
  - Privilege to create EC2 instances and manage EC2 resources
  - Create and configure an Application Load Balancer
  - Create and configure an Auto Scaling Group
- Ec2 Key Pair for the region


## Installation
 Clone or fork this repository into any folder of your choice

* Be sure to have an S3 bucket created to house Terraform Remote State unique for each team
  * See readme in the MGMT Folder

* In your terminal, goto the folder where you've placed this code, then change directory to one of the Teams
  * Currently each team has a file called "terraform.tfvars", this repository bogus values in the file, be sure to change the values to represent values appropriate for your deployment.



* execute the following commands:
   1. `Terraform init`
   2. `terraform validate`
   3. `Terraform apply`



