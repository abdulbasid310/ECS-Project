output "alb_arn" {
    value = aws_alb.gatus_alb.arn
}

output "target_group_arn" {
    value = aws_alb_target_group.gatus_target.arn
}

output "alb_dns_name" {
    value = aws_alb.gatus_alb.dns_name
}

output "alb_zone_id" {
    value = aws_alb.gatus_alb.zone_id
}

output "alb_sg" {
    value = aws_security_group.alb_sg.id
}