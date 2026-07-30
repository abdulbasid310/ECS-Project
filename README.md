Project Overview

This project deploys Gatus (an open source end-point health monitoring application) on AWS. This project uses docker to containerise the application, 
terraform to provision the cloud infrastructure and github actions to automate application and infrastructure deployment through CI/CD pipelines.
The application is hosted on Amazon ECS Fargate behind an ALB with HTTPS enabled using AWS ACM. The primary domain is managed by cloudlfare. A delegated
Route 53 hosted zone is used to manage AWS resources.

About the app:
Gatus is a health dashboard that allows you to configure health checks for each of your features so that they can be monitored without existing traffic.
This allows Gatus to alert you to services being down before any potential impact on clients.

Local Development:


Architecture Diagram:

Components:
Network - Two public subnets in separate availability zones for high availability and resilience
Compute - ECS fargate used for serverless computing
Security - HTTPS redirect 


Project Structure
'''text
├── .github/
│   └── workflows/
│       ├── application.yml
│       └── terraform.yml
|       └── tfdestroy.yml
├── gatus/
│   ├── config/
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── ...
├── infra/
│   ├── modules/
│   │   ├── acm/
│   │   ├── alb/
│   │   ├── ecs/
│   │   ├── ecr/
│   │   └── vpc/
│   ├── backend.tf
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── outputs.tf
|   └── terraform.tfvars
|   └── .gitignore
├── README.md
'''
