locals {
  command               = jsonencode(var.command)
  dnsSearchDomains      = jsonencode(var.dnsSearchDomains)
  dnsServers            = jsonencode(var.dnsServers)
  dockerLabels          = jsonencode(var.dockerLabels)
  dockerSecurityOptions = jsonencode(var.dockerSecurityOptions)
  entryPoint            = jsonencode(var.entryPoint)
  environment_variables = jsonencode(var.environment_variables)
  extraHosts            = jsonencode(var.extraHosts)

  healthCheck = replace(jsonencode(var.healthCheck), local.classes["digit"], "$1")

  links = jsonencode(var.links)

  linuxParameters = replace(
    replace(
      replace(jsonencode(var.linuxParameters), "/\"1\"/", "true"),
      "/\"0\"/",
      "false",
    ),
    local.classes["digit"],
    "$1",
  )

  logConfiguration_default = {
    logDriver = var.log_driver
    options   = var.log_options
  }

  logConfiguration = replace(
    replace(
      jsonencode(local.logConfiguration_default),
      "/\"1\"/",
      "true",
    ),
    "/\"0\"/",
    "false",
  )

  mountPoints = replace(
    replace(jsonencode(var.mountPoints), "/\"1\"/", "true"),
    "/\"0\"/",
    "false",
  )

  portMappings = replace(jsonencode(var.portMappings), "/\"([0-9]+\\.?[0-9]*)\"/","$1")


  repositoryCredentials = jsonencode(var.repositoryCredentials)
  resourceRequirements  = jsonencode(var.resourceRequirements)
  secrets               = jsonencode(var.secrets)
  systemControls        = jsonencode(var.systemControls)

  ulimits = replace(jsonencode(var.ulimits), local.classes["digit"], "$1")

  volumesFrom = replace(
    replace(jsonencode(var.volumesFrom), "/\"1\"/", "true"),
    "/\"0\"/",
    "false",
  )

  # re2 ASCII character classes
  # https://github.com/google/re2/wiki/Syntax
  classes = {
    digit = "/\"(-[[:digit:]]|[[:digit:]]+)\"/"
  }

  container_definition = format("[%s]", data.template_file.container_definition.rendered)

  container_definitions = replace(local.container_definition, "/\"(null)\"/", "$1")
}

data "template_file" "container_definition" {
  template = file("${path.module}/templates/container-definition.json.tpl")

  vars = {
    command                = local.command == "[]" ? "null" : local.command
    cpu                    = var.cpu == 0 ? "null" : var.cpu
    disableNetworking      = var.disableNetworking ? true : false
    dnsSearchDomains       = local.dnsSearchDomains == "[]" ? "null" : local.dnsSearchDomains
    dnsServers             = local.dnsServers == "[]" ? "null" : local.dnsServers
    dockerLabels           = local.dockerLabels == "{}" ? "null" : local.dockerLabels
    dockerSecurityOptions  = local.dockerSecurityOptions == "[]" ? "null" : local.dockerSecurityOptions
    entryPoint             = local.entryPoint == "[]" ? "null" : local.entryPoint
    environment            = local.environment_variables
    essential              = var.essential ? true : false
    extraHosts             = local.extraHosts == "[]" ? "null" : local.extraHosts
    healthCheck            = local.healthCheck == "{}" ? "null" : local.healthCheck
    hostname               = var.hostname == "" ? "null" : var.hostname
    image                  = var.image == "" ? "null" : var.image
    interactive            = var.interactive ? true : false
    links                  = local.links == "[]" ? "null" : local.links
    linuxParameters        = local.linuxParameters == "{}" ? "null" : local.linuxParameters
    logConfiguration       = var.log_driver == "" ? "null" : local.logConfiguration
    memory                 = var.memory == 0 ? "null" : var.memory
    memoryReservation      = var.memoryReservation == 0 ? "null" : var.memoryReservation
    mountPoints            = local.mountPoints
    name                   = var.container_name == "" ? "null" : var.container_name
    portMappings           = local.portMappings
    privileged             = var.privileged ? true : false
    pseudoTerminal         = var.pseudoTerminal ? true : false
    readonlyRootFilesystem = var.readonlyRootFilesystem ? true : false
    repositoryCredentials  = local.repositoryCredentials == "{}" ? "null" : local.repositoryCredentials
    resourceRequirements   = local.resourceRequirements == "[]" ? "null" : local.resourceRequirements
    secrets                = local.secrets == "[]" ? "null" : local.secrets
    systemControls         = local.systemControls == "[]" ? "null" : local.systemControls
    ulimits                = local.ulimits == "[]" ? "null" : local.ulimits
    user                   = var.user == "" ? "null" : var.user
    volumesFrom            = local.volumesFrom
    workingDirectory       = var.workingDirectory == "" ? "null" : var.workingDirectory
  }
}

resource "local_file" "container_definition" {
  count = var.enable_module ? 1 : 0

  content  = jsonencode(local.container_definitions)
  filename = "${path.cwd}/container_definition.json"
}

data "aws_ecs_cluster" "main" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "main" {
  count = var.enable_module ? 1 : 0

  container_definitions = local.container_definitions
  cpu                   = var.cpu
  memory                = var.memory
  execution_role_arn    = var.execution_role_arn
  family                = var.service_name
  network_mode          = var.network_mode
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = var.task_role_arn
  dynamic "volume" {
    for_each = var.volumes
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
    }
  }
  tags = merge(
    var.tags,
    {
      "ManagedBy" = "terraform"
    },
  )
}

resource "aws_ecs_service" "main" {
  count                              = var.enable_module ? 1 : 0
  name                               = var.service_name
  cluster                            = data.aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.main[count.index].arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = "100"

  deployment_controller {
    type = var.deployment_controller_type
  }

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
  for_each = var.load_balancer
  content {
    target_group_arn = load_balancer.value["target_group_arn"]
    container_port   = load_balancer.value["container_port"]
    container_name   = load_balancer.value["target_group_arn"] == null ? null : var.container_name
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

