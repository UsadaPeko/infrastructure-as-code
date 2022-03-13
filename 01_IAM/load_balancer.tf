resource "aws_iam_user" "load-balancer" {
  name = "loadbalancer"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "load-balancer-access-key" {
  user = aws_iam_user.load-balancer.name
}

resource "aws_iam_user_policy" "load-balancer-user-policy" {
  name = "test"
  user = aws_iam_user.load-balancer.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
