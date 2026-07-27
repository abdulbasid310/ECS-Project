
variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-west-2"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "health_check_path" {
  default = "/health"
}

variable "fargate_cpu" {
  description = "Units to provision"
  default     = "1024"
}

variable "fargate_memory" {
  description = "fargate memory to provision"
  default     = "2048"
}

variable "app_image" {
  description = "ECR image URI"
  type        = string
}

variable "domain_name" {
    default = "tm.labs.abdulbasiddevops.uk"
    type = string
}

variable "az_A" {
    type = string
}

variable "az_B" {
    type = string
}

# Terraform pipeline test6