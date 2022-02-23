resource "aws_eip" "stage_server" {
  instance = aws_instance.stage_server.id
  vpc      = true
}
