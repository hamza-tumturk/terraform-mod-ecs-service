resource "aws_codedeploy_app" "main" {
  count = var.deployment_controller_type == "CODE_DEPLOY" ? 1 : 0

  compute_platform = "ECS"
  name             = var.container_name
}

resource "aws_codedeploy_deployment_group" "main" {
  count = var.deployment_controller_type == "CODE_DEPLOY" ? 1 : 0

  app_name               = aws_codedeploy_app.main[count.index].name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.service_name}-${var.container_name}"
  service_role_arn       = var.execution_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 300
    }
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = aws_ecs_service.main[count.index].name
  }
}