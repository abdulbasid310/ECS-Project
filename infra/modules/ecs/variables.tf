variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "target_group_arn" {
    type = string
}

variable "fargate_cpu" {
    type = number
}

variable "fargate_memory" {
    type = number
}

variable "app_port" {
    type = number
}

variable "app_image" {
    type = string
}

variable "alb_sg" {
    type = string
}