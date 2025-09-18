provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web" {
  ami           = "ami-075449515af5df0d1"
  instance_type = "t3.micro"
  key_name      = "keyInterminal"
  tags = {
    Name = "terraform machine2"
  }
}

