resource "aws_appautoscaling_target" "main" {
  count = var.autoscaling_enabled && var.enable_module ? 1 : 0

  max_capacity       = var.autoscale_max_capacity
  min_capacity       = var.autoscale_min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main[count.index].name}"
  role_arn           = var.execution_role_arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "high_threshold" {
  count = var.autoscaling_enabled && var.enable_module ? 1 : 0

  alarm_name          = "{aws_ecs_service.main[count.index].name}-${lookup(var.metrics_alarms[count.index], "metric_name")}-high-threshold"
  comparison_operator = lookup(var.metrics_alarms[count.index], "comparison_operator_high")
  evaluation_periods  = lookup(var.metrics_alarms[count.index], "evaluation_periods")
  metric_name         = lookup(var.metrics_alarms[count.index], "metric_name")
  namespace           = lookup(var.metrics_alarms[count.index], "namespace")
  period              = lookup(var.metrics_alarms[count.index], "period")
  statistic           = lookup(var.metrics_alarms[count.index], "statistic")
  threshold           = lookup(var.metrics_alarms[count.index], "scale_up_threshold")

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main[count.index].name
  }

  alarm_actions = [aws_appautoscaling_policy.app_up[count.index].arn]
  depends_on    = [aws_appautoscaling_policy.app_up]
}

resource "aws_cloudwatch_metric_alarm" "low_threshold" {
  count = var.autoscaling_enabled && var.enable_module ? 1 : 0

  alarm_name          = "{aws_ecs_service.main[count.index].name}-${lookup(var.metrics_alarms[count.index], "metric_name")}-low-threshold"
  comparison_operator = lookup(var.metrics_alarms[count.index], "comparison_operator_low")
  evaluation_periods  = lookup(var.metrics_alarms[count.index], "evaluation_periods")
  metric_name         = lookup(var.metrics_alarms[count.index], "metric_name")
  namespace           = lookup(var.metrics_alarms[count.index], "namespace")
  period              = lookup(var.metrics_alarms[count.index], "period")
  statistic           = lookup(var.metrics_alarms[count.index], "statistic")
  threshold           = lookup(var.metrics_alarms[count.index], "scale_down_threshold")

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main[count.index].name
  }

  alarm_actions = [aws_appautoscaling_policy.app_down[count.index].arn]
}

resource "aws_appautoscaling_policy" "app_up" {
  count = var.autoscaling_enabled && var.enable_module ? 1 : 0

  name               = "app-scale-up"
  service_namespace  = aws_appautoscaling_target.main[count.index].service_namespace
  resource_id        = aws_appautoscaling_target.main[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.main[count.index].scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = [aws_appautoscaling_target.main]

}

resource "aws_appautoscaling_policy" "app_down" {
  count = var.autoscaling_enabled && var.enable_module ? 1 : 0

  name               = "app-scale-down"
  service_namespace  = aws_appautoscaling_target.main[count.index].service_namespace
  resource_id        = aws_appautoscaling_target.main[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.main[count.index].scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = [aws_appautoscaling_target.main]
}