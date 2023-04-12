resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "ansible_private_key" {
  content  = tls_private_key.ssh_key.private_key_openssh
  filename       = pathexpand("~/.ssh/ansible")
  file_permission = "0600"
}

resource "aws_instance" "worker_1" {
  ami                    = "ami-0ba918b8809f8d365"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id = tolist(data.aws_subnet_ids.public.ids)[0]
  tags                   = {
    Name = "node_amazonlinux"
    Type = "Ubuntu"
    User = "ubuntu"
  }
}