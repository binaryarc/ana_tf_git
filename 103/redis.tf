resource "aws_elasticache_cluster" "ana" {
  cluster_id           = "anaredis"
  engine               = "redis"
  node_type            = "cache.t3.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis.id]
  subnet_group_name    =  aws_elasticache_subnet_group.ana.id
}

resource "aws_security_group" "redis" {
  name = "redis-SG"
  vpc_id      = data.terraform_remote_state.s3.outputs.vpc_id ##자신의 vpc id로 바꿔서
  ingress {
    description = "redis SG"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_security_group.eks.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "redis-SG"
  }
}

resource "aws_elasticache_subnet_group" "ana" {
  name       = "redis-subnet-group"
  subnet_ids = [data.terraform_remote_state.s3.outputs.subnet_pri_a_02_id, data.terraform_remote_state.s3.outputs.subnet_pri_c_02_id]
}