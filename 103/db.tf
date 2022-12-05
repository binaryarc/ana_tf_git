resource "aws_security_group" "db" {

  description = "Allow_MYSQL INBOUND traffic"
  vpc_id      = data.terraform_remote_state.s3.outputs.vpc_id
  
  ingress {
    description = "MYSQLfrom VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    /*security_groups = [aws_security_group.eks.id]*/
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DB-SG"
  }
}


resource "aws_db_subnet_group" "db" {
  name       = "ana_db_subnet"
  subnet_ids = [data.terraform_remote_state.s3.outputs.subnet_pri_a_03_id, data.terraform_remote_state.s3.outputs.subnet_pri_c_03_id]

  tags = {
    Name = "ANA-DB-SUBNET"
  }
}

resource "aws_db_instance" "db" {
  identifier        = "anaconda"
  allocated_storage = 10
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "petclinic"
  username          = "petclinic"
  password          = "petclinic"
  publicly_accessible = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  multi_az               = true
}