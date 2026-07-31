module "vpc" {
    source = "./modules/vpc"
    az_A = var.az_A
    az_B = var.az_B
}

module "ecr" {
    source = "./modules/ecr"
}

module "alb" {
    source = "./modules/alb"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.public_subnet_ids
    certificate_arn = module.acm.certificate_arn
}

module "ecs" {
    source = "./modules/ecs"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnet_ids
    target_group_arn = module.alb.target_group_arn
    fargate_cpu = var.fargate_cpu
    fargate_memory = var.fargate_memory
    app_image = "${module.ecr.repository_url}:latest"
    app_port = var.app_port
    alb_sg = module.alb.alb_sg

    depends_on = [module.alb]

}

module "acm" {
    source = "./modules/acm"

    domain_name = var.domain_name
    alb_dns_name = module.alb.alb_dns_name
    alb_zone_id = module.alb.alb_zone_id
    

}