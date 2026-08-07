# Creates a hosted zone for the delegated subdomain
resource "aws_route53_zone" "labs" {
    name = "labs.abdulbasiddevops.uk"

    tags = {
    Name = "subdomain-hosted-zone"
    }
}