module "lambda_function" {
  source = ".././aws_lambda_function"

  source_file_path = "eks.py"
  runtime          = "python3.9"

  environment_variables = {
    cluster_name = var.cluster_name
  }
  
  iam_role_arn = var.lambda_iam_role_arn
}

resource "aws_cloudwatch_metric_alarm" "eks_cpu_threshold_alarm" {
  alarm_name          = "eks_cpu_threshold_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 30
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 0.7
  alarm_description   = "This metric monitors the EKS cluster's average CPU utilization."
  
  dimensions = {
    ClusterName = var.cluster_name
  }

  datapoints_to_alarm = 1

  alarm_actions = [
    aws_autoscaling_policy.autoscale_to_zero.arn,
  ]
}

resource "aws_autoscaling_policy" "autoscale_to_zero" {
  name = "autoscale_to_zero_${module.eks.cluster_name}"
  policy_type = "SimpleScaling"

  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"

  autoscaling_group_name =  module.eks.eks_managed_node_groups_autoscaling_group_names[0]
}