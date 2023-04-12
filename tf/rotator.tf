# data "aws_serverlessapplicationrepository_application" "rotator" {
#   application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSMySQLRotationSingleUser"
# }

# data "aws_partition" "current" {}
# data "aws_region" "current" {}

# resource "aws_serverlessapplicationrepository_cloudformation_stack" "rotate_stack" {
#   name             = "Rotate-${random_id.id.hex}"
#   application_id   = data.aws_serverlessapplicationrepository_application.rotator.application_id
#   semantic_version = data.aws_serverlessapplicationrepository_application.rotator.semantic_version
#   capabilities     = data.aws_serverlessapplicationrepository_application.rotator.required_capabilities

#   parameters = {
#     endpoint            = "https://secretsmanager.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}"
#     functionName        = "rotator-${random_id.id.hex}"
#     vpcSubnetIds        = module.vpc.private_subnets[0]
#     vpcSecurityGroupIds = aws_security_group.sec_manager.id
#   }
# }

# resource "aws_secretsmanager_secret_rotation" "ng_secret_rotation" {
#   secret_id           = aws_secretsmanager_secret_version.ng_aline_secret_val.secret_id
#   rotation_lambda_arn = aws_serverlessapplicationrepository_cloudformation_stack.rotate_stack.outputs.RotationLambdaARN

#   rotation_rules {
#     automatically_after_days = 30
#   }
# }
