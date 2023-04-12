# locals {
#   special_characters = "!#$%^&*()-_=+[]{}<>:?"
# }

# resource "aws_security_group" "sec_manager" {
#   name_prefix = "secret_manager_sg"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "random_password" "db_master_pass" {
#   length           = 40
#   special          = true
#   min_special      = 5
#   override_special = local.special_characters
# }

# resource "random_password" "jwt_key" {
#   length           = 74
#   special          = true
#   min_special      = 5
#   override_special = local.special_characters
# }

# resource "random_password" "encrypt_key" {
#   length           = 24
#   special          = true
#   min_special      = 1
#   override_special = local.special_characters
# }

# resource "random_id" "id" {
#   byte_length = 4
# }

# resource "aws_secretsmanager_secret" "ng_aline_secret" {
#   name = "ng-aline-secret-${random_id.id.hex}"
# }

# resource "aws_secretsmanager_secret_version" "ng_aline_secret_val" {
#   secret_id = aws_secretsmanager_secret.ng_aline_secret.id
#   secret_string = jsonencode({
#     username   = "admin"
#     dbname     = "aline"
#     password   = random_password.db_master_pass.result
#     host       = module.rds_instance.rds_endpoint
#     jwtkey     = random_password.jwt_key.result
#     encryptkey = random_password.encrypt_key.result
#     engine     = "mysql"
#   })
  
#   depends_on = [
#     aws_secretsmanager_secret.ng_aline_secret
#   ]
# }

# resource "aws_vpc_endpoint" "ng_secretmanager_endpoint" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.sec_manager.id]
# }

# # resource "aws_iam_policy" "secret_policy" {
# #   name        = "aline-secret-${random_id.id.hex}-policy"
# #   path        = "/"
# #   description = "Aline secret policy"

# #   policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [
# #       {
# #         Action = [
# #           "secretsmanager:GetSecretValue",
# #           "secretsmanager:DescribeSecret"
# #         ]
# #         Effect   = "Allow"
# #         Resource = aws_secretsmanager_secret.ng_aline_secret.arn
# #       }
# #     ]
# #   })
# # }
