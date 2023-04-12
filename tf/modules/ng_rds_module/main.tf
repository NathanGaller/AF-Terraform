locals {
  mysql_port = var.mysql_port
}

resource "aws_security_group" "sec_grp_rds" {
  name_prefix = "${var.cluster_name}-rds-sec_grp"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow-workers-nodes-communications" {
  description              = "Allow nodes and DB to communicate."
  from_port                = local.mysql_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sec_grp_rds.id
  source_security_group_id = var.node_security_group_id
  to_port                  = local.mysql_port
  type                     = "ingress"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.cluster_name}-ng-rds"

  engine              = "mysql"
  engine_version      = "8.0.28"
  instance_class      = "db.t3.micro"
  allocated_storage   = 5
  storage_encrypted   = false
  publicly_accessible = true

  # db_name  = "aline"
  # username = "admin"
  # password = "testaline"
  
  db_name  = "aline"
  username = "admin"
  password = var.password
  port     = local.mysql_port

  vpc_security_group_ids = [aws_security_group.sec_grp_rds.id]

  create_db_subnet_group = true
  subnet_ids = var.subnet_ids

  family = "mysql8.0"
  major_engine_version = "8.0"
}