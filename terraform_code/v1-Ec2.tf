provider "aws" {

    region = "us-east-1"

}


resource "aws_instance" "demo-server" {

    ami = "ami-022e1a32d3f742bd8"
    instance_type = "t2.micro"
    key_name = "rtp-03"
    subnet_id = "subnet-0e9111972d5d28790"
    associate_public_ip_address = true
    security_groups = ["demo-sg"]
  
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "for ssh access"

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}