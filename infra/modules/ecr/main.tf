resource "aws_ecr_repository" "gatus" {
    name = "gatus-repo"

    image_tag_mutability = "MUTABLE"

    force_delete = true
    
}