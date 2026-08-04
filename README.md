# Deploying Gatus on AWS ECS Fargate

## Project Overview

This project deploys Gatus (an open source end-point health monitoring application) on AWS. This project uses docker to containerise the application, 
terraform to provision the cloud infrastructure and github actions to automate application and infrastructure deployment through CI/CD pipelines.
The application is hosted on Amazon ECS Fargate behind an ALB with HTTPS enabled using AWS ACM. The primary domain is managed by cloudlfare. A delegated
Route 53 hosted zone is used to manage AWS resources.

## About the app
Gatus is a health dashboard that allows you to configure health checks for each of your features so that they can be monitored without existing traffic. This allows the app to alert you to services being down before any potential impact on clients.

I have chosen Gatus because it is lightweight and has a small resource footprint, making it quick to deploy and cost-effective on ECS because you only pay for resources you allocate. Gatus is also container native, not depending on any underlying hardware which makes containers replaceable, reducing downtime.

This app is hosted on ECS fargate because of its serverless management. This provides faster deployments and removes the need to manually manage guest operating systems or configure scaling. ECS has auto-scaling capabilities that can be configured based on CPU or memory usage.

I am expecting few users, in the 10s, however the architecture is designed with scalability in mind. CPU-based auto-scaling is configured to adjust the number of running tasks. The app is also available in two separate availability zones for resilience and high availability. The ALB distributes traffic across healthy ECS tasks and is configured with health checks to automatically replace failed tasks.


## Local Development

```
git clone https://github.com/abdulbasid310/ECS-Project.git
cd ECS-Project
cd gatus
docker build -t gatus .
docker run -p 8080:8080 gatus
Then open http://localhost:8080
```
## App Demo

<img width="1440" height="900" alt="Screenshot 2026-07-24 at 23 25 30" src="https://github.com/user-attachments/assets/6d3c04d9-853f-4679-a76d-0fa7ad285298" />


## Architecture Diagram



<img width="920" height="1215" alt="architecture drawio" src="https://github.com/user-attachments/assets/b4cd7a28-8497-4f74-9a2c-e09eb2131ec6" />




### Components

#### Network 
- Two public subnets
- Two private subnets
- Internet gateway
- Nat gateway

#### Compute
- ECS fargate 
- CPU-based autoscaling

#### Containerisation
- Multi-stage docker build
- Amazon ECR
- Distroless image
- Container runs with non root user

### Infrastructure as Code
- Terraform
- Modular Terraform architecture
- Remote state (Amazon S3) with native S3 state locking

### CI/CD
- GitHub Actions
- GitHub OIDC authentication
- Automated Docker image builds
- Automated ECS deployments


## Project Structure
```text
.
├── .github/
│   └── workflows/
│       ├── application.yml
│       └── terraform.yml
|       └── tfdestroy.yml
├── bootstrap/
│   ├── backend.tf
│   ├── iam.tf
│   ├── main.tf
│   ├── oidc.tf
│   ├── outputs.tf
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
```

## CI/CD
##### Application pipeline
- pushes docker image to ECR for the ECS tasks to pull and triggers on push to main when there are changes in the app folder
##### Terraform deploy pipeline
- deploys terraform infrastructure on push to main when infrastructure folder has changes
##### Terraform destroy pipeline
- triggered manually by a button on github


<img width="1440" height="900" alt="Screenshot 2026-07-27 at 21 33 24" src="https://github.com/user-attachments/assets/907f5956-e245-4551-9841-80f42d92943d" />


<img width="1437" height="809" alt="Screenshot 2026-07-27 at 22 53 55" src="https://github.com/user-attachments/assets/51e42e2c-f4b9-437d-a4ac-350eebd73143" />


<img width="1440" height="714" alt="Screenshot 2026-07-28 at 00 53 58" src="https://github.com/user-attachments/assets/7204ddb0-e02e-4519-be91-38118dc45da3" />






