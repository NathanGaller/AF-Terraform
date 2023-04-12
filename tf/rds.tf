# resource "aws_security_group" "sec_grp_rds" {
#   name_prefix = "${var.cluster_name}-rds-sec_grp"
#   vpc_id      = "${module.vpc.vpc_id}"

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   depends_on = [module.eks]
# }

# resource "aws_security_group_rule" "allow-workers-nodes-communications" {
#   description              = "Allow nodes and DB to communicate."
#   from_port                = 3306
#   protocol                 = "tcp"
#   security_group_id        = "${aws_security_group.sec_grp_rds.id}"
#   source_security_group_id = "${module.eks.node_security_group_id}"
#   to_port                  = 3306
#   type                     = "ingress"
# }

# module "db" {
#   version = "5.6.0"
#   source  = "terraform-aws-modules/rds/aws"

#   identifier = "${var.cluster_name}-ng-rds"

#   engine              = "mysql"
#   engine_version      = "8.0.28"
#   instance_class      = "db.t3.micro"
#   allocated_storage   = 5
#   storage_encrypted   = false
#   publicly_accessible = true

#   db_name = "aline"
#   username = "admin"
#   password = "testaline"
#   port     = "3306"

#   vpc_security_group_ids = ["${aws_security_group.sec_grp_rds.id}"]

#   create_db_subnet_group = true
#   subnet_ids = "${module.vpc.private_subnets}"

#   family = "mysql8.0"
#   major_engine_version = "8.0"
# }

# module "rds_instance" {
#   source = "./modules/ng_rds_module"

#   cluster_name           = var.cluster_name
#   vpc_id                 = module.vpc.vpc_id
#   node_security_group_id = module.eks_cluster.worker_sec_group
#   subnet_ids             = module.vpc.private_subnets
#   password               = random_password.db_master_pass.result
# }