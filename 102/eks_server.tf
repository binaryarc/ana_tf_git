resource "aws_instance" "EKS-Server" {
  ami                         = "ami-0c76973fbe0ee100c" # Amazon Linux 2 (us-east-2)
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.eks.id]
  user_data_replace_on_change = true
  subnet_id                   = data.terraform_remote_state.s3.outputs.subnet_pri_a_01_id
  key_name                    = "bastion-key"
  depends_on                  = [aws_instance.Bastion-Server]

  user_data = file("eks_userdata.sh")

  tags = {
    Name = "ANA-WC-EKS-Server"
  }
}

resource "aws_security_group" "eks" {
  vpc_id      = data.terraform_remote_state.s3.outputs.vpc_id
  name        = "EKS-SG"
  description = "allow HTTP inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EKS-SG"
  }
}
