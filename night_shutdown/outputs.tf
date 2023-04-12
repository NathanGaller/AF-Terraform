output "private_key" {
  value     = tls_private_key.control_key.private_key_pem
  sensitive = true
}

output "instance_public_ip" {
  value = aws_instance.ansible_runner.public_ip
}