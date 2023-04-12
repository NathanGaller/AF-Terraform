# output "rds_security_group_id" {
#   description = "The ID of the RDS security group."
#   value       = aws_security_group.sec_grp_rds.id
# }

# output "rds_endpoint" {
#   description = "The RDS instance endpoint."
#   value       = module.db.this_db_instance_endpoint
# }

# output "rds_instance_id" {
#   description = "The ID of the RDS instance."
#   value       = module.db.this_db_instance_id
# }

output "rds_endpoint" {
    value = module.db.db_instance_endpoint
}