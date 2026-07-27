variable "vpc_id" {
    type = string
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "certificate_arn" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}
    