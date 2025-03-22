resource "aws_security_group" "Project-SG" {
  name        = "Project-SG"
  description = "Open 22,443,80,8080,9000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-SG"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.large"
  key_name               = "sample-key"
  vpc_security_group_ids = [aws_security_group.Project-SG.id]
  user_data              = templatefile("./resource.sh", {})

  tags = {
    Name = "swiggy-server"
  }
  root_block_device {
    volume_size = 30
  }
  depends_on = [aws_security_group.Project-SG]
}
