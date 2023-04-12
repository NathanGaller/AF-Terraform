variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group should be created."
  type        = string
}

variable "node_security_group_id" {
  description = "The security group ID for the worker nodes."
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs where the RDS instance should be created."
  type        = list(string)
}

variable "mysql_port" {
  description = "The port for the MySQL database."
  type        = number
  default     = 3306
}

variable "password" {
  type        = string
}