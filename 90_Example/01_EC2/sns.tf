# resource "aws_sns_topic" "iac-sns-topic" {
#   name = "iac-sns-topic"
# }

# resource "aws_sns_topic_subscription" "iac-sns-topic-subscription" {
#   topic_arn = aws_sns_topic.iac-sns-topic.arn
#   protocol  = "email"
#   endpoint  = "jeonghyeon.rhea@gmail.com"
# }
