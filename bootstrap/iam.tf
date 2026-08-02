
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"
  max_session_duration = 7200

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
              "token.actions.githubusercontent.com:sub" = "repo:abdulbasid310@130777760/ECS-Project@1314350796:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_poweruser" {

  role = aws_iam_role.github_actions_role.name

  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"

}


resource "aws_iam_role_policy_attachment" "github_actions_iam" {

  role = aws_iam_role.github_actions_role.name

  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"

}

