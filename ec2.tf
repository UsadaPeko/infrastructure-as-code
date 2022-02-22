resource "aws_instance" "backstage_server" {
  ami           = "ami-0454bb2fefc7de534"
  instance_type = "t3.nano"
  key_name = "Home"

  tags = {
    Name = "RheaSoBackstageEC2"
  }
}
