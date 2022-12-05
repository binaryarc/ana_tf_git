resource "aws_instance" "Monitoring-Server" {
  ami                         = "ami-0c76973fbe0ee100c" # Amazon Linux 2 (us-east-2)
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.monitoring.id]
  user_data_replace_on_change = true
  subnet_id                   = data.terraform_remote_state.s3.outputs.subnet_pub_a_id
  key_name                    = "bastion-key"

  user_data = file("monitoring_userdata.sh")

  tags = {
    Name = "Monitoring-Server"
  }
}

resource "aws_security_group" "monitoring" {
  vpc_id      = data.terraform_remote_state.s3.outputs.vpc_id
  name        = "monitoring-SG"
  description = "allow HTTP inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Monitoring-SG"
  }
}