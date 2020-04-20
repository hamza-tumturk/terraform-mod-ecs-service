output "service_id" {
  value = aws_ecs_service.main.*.id
}

output "service_name" {
  value = aws_ecs_service.main.*.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.main.*.arn
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.main.*.revision
}