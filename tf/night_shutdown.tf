# resource "tls_private_key" "default" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_file" "private_key" {
#   content  = tls_private_key.default.private_key_pem
#   filename = "secret/private_key.pem"
#   file_permission = "0600"
# }

# resource "aws_key_pair" "default" {
#   key_name   = "generated_key"
#   public_key = tls_private_key.default.public_key_openssh
# }

# resource "aws_security_group" "allow_ssh" {
#   name        = "allow_ssh"
#   description = "Allow SSH traffic"

#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_iam_role" "ssm_instance_role" {
#   name = "ssm_instance_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_instance_profile" "ssm_instance_profile" {
#   name = "ssm_instance_profile"
#   role = aws_iam_role.ssm_instance_role.name
# }

# resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.ssm_instance_role.name
# }

# resource "aws_instance" "ansible_runner" {
#   ami           = "ami-0ba918b8809f8d365"
#   instance_type = "t2.micro"

#   key_name          = aws_key_pair.default.key_name
#   user_data         = file("static/user_data.sh")
#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

#   subnet_id = module.vpc.public_subnets[0]

#   connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("secret/private_key.pem")
#       host        = self.public_ip
#   }


#   tags = {
#     Name = "ansible-runner"
#   }

#   vpc_security_group_ids = [
#     aws_security_group.allow_ssh.id
#   ]
# }


# resource "aws_iam_role" "lambda_role" {
#   name = "lambda_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "lambda_ec2_permissions" {
#   name = "lambda_ec2_permissions"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:DescribeInstances",
#           "ec2:StartInstances",
#           "ec2:StopInstances"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#       {
#         Action = [
#           "ssm:SendCommand",
#           "ssm:GetCommandInvocation",
#           "ssm:DescribeInstanceInformation"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda_role.name
# }

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "static/lambdasrc/ansible_shutdown"
#   output_path = "static/lambdasrc/zip/ansible_shutdown.zip"
# }

# resource "aws_lambda_function" "ansible_runner" {
#   function_name = "ansibleRunner"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "lambda_function.lambda_handler"

#   runtime = "python3.8"
#   timeout = 600

#   filename = data.archive_file.lambda_zip.output_path
# }

# resource "aws_cloudwatch_event_rule" "daily_event" {
#   name                = "daily-event"
#   schedule_expression = "cron(0 22 * * ? *)" # 10 PM daily
# }

# resource "aws_cloudwatch_event_target" "run_ansible_playbook" {
#   rule      = aws_cloudwatch_event_rule.daily_event.name
#   target_id = "RunAnsiblePlaybook"
#   arn       = aws_lambda_function.ansible_runner.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ansible_runner.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.daily_event.arn
# }