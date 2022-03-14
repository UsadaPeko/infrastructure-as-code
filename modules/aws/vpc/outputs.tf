output "id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}
