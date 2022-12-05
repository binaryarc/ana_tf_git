resource "aws_instance" "Bastion-Server" {
  ami                         = "ami-0c76973fbe0ee100c" # Amazon Linux 2 (us-east-2)
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  user_data_replace_on_change = true
  subnet_id                   = data.terraform_remote_state.s3.outputs.subnet_pub_a_id
  key_name                    = "bastion-key"

  user_data = file("bastion_userdata.sh")

  tags = {
    Name = "Bastion-Server"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id      = data.terraform_remote_state.s3.outputs.vpc_id
  name        = "Bastion-SG"
  description = "allow HTTP inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Bastion-SG"
  }
}

# resource "aws_key_pair" "ANAkey" {
#   key_name   = "ANAkey"
#   public_key = file("ANAkey.pub")
# }