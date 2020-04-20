variable "tags" {
  description = "Additional tags to be put on the resources"
  type        = map(string)
  default     = {}
}
variable "enable_module" {
  description = "Controls if module should be run, as count is not usable for modules"
  type        = string
  default     = true
}
variable "cluster_name" {
}

variable "desired_count" {
  default = 1
}

variable "service_name" {
}

variable "region" {
  default = "us-east-1"
}

variable "subnet_ids" {
  type = list(string)
}

variable "assign_public_ip" {
  default = "false"
}

variable "security_groups" {
  default = []
  type    = list(string)
}

variable "command" {
  default     = []
  description = "The command that is passed to the container"
  type        = list(string)
}

variable "cpu" {
  default     = 0
  description = "The number of cpu units reserved for the container"
}

variable "disableNetworking" {
  default     = false
  description = "When this parameter is true, networking is disabled within the container"
}

variable "dnsSearchDomains" {
  default     = []
  description = "A list of DNS search domains that are presented to the container"
  type        = list(string)
}

variable "dnsServers" {
  default     = []
  description = "A list of DNS servers that are presented to the container"
  type        = list(string)
}

variable "dockerLabels" {
  default     = {}
  description = "A key/value map of labels to add to the container"
  type        = map(string)
}

variable "dockerSecurityOptions" {
  default     = []
  description = "A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems"
  type        = list(string)
}

variable "entryPoint" {
  default     = []
  description = "The entry point that is passed to the container"
  type        = list(string)
}

variable "environment_variables" {
  default     = []
  description = "The environment variables to pass to a container"
  type        = list(any)
}

variable "essential" {
  default     = true
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped"
}

variable "execution_role_arn" {
  default     = ""
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
}

variable "extraHosts" {
  default     = []
  description = "A list of hostnames and IP address mappings to append to the /etc/hosts file on the container"
  type        = list(string)
}

variable "healthCheck" {
  default     = {}
  description = "The health check command and associated configuration parameters for the container"
  type        = map(string)
}

variable "hostname" {
  default     = ""
  description = "The hostname to use for your container"
}

variable "image" {
  default     = ""
  description = "The image used to start a container"
}

variable "interactive" {
  default     = false
  description = "When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated"
}

variable "links" {
  default     = []
  description = "The link parameter allows containers to communicate with each other without the need for port mappings"
  type        = list(string)
}

variable "linuxParameters" {
  default     = {}
  description = "Linux-specific modifications that are applied to the container, such as Linux KernelCapabilities"
  type        = map(string)
}

variable "logConfiguration" {
  default     = {}
  description = "The log configuration specification for the container"
  type        = map(string)
}

variable "memory" {
  default     = 0
  description = "The hard limit (in MiB) of memory to present to the container"
}

variable "memoryReservation" {
  default     = 0
  description = "The soft limit (in MiB) of memory to reserve for the container"
}

variable "mountPoints" {
  default     = []
  description = "The mount points for data volumes in your container"
  type        = list(string)
}

variable "container_name" {
  default     = ""
  description = "The name of a container"
}

variable "network_mode" {
  default     = "awsvpc"
  description = "The Docker networking mode to use for the containers in the task"
}

variable "placement_constraints" {
  default     = []
  description = "An array of placement constraint objects to use for the task"
  type        = list(string)
}

variable "portMappings" {
  default     = []
  description = "The list of port mappings for the container"
  type = list(object({
    containerPort = number
    protocol      = string
  }))
}

variable "privileged" {
  default     = false
  description = "When this parameter is true, the container is given elevated privileges on the host container instance (similar to the root user)"
}

variable "pseudoTerminal" {
  default     = false
  description = "When this parameter is true, a TTY is allocated"
}

variable "readonlyRootFilesystem" {
  default     = false
  description = "When this parameter is true, the container is given read-only access to its root file system"
}

variable "register_task_definition" {
  default     = true
  description = "Registers a new task definition from the supplied family and containerDefinitions"
}

variable "repositoryCredentials" {
  default     = {}
  description = "The private repository authentication credentials to use"
  type        = map(string)
}

variable "requires_compatibilities" {
  default     = ["FARGATE"]
  description = "The launch type required by the task"
  type        = list(string)
}

variable "resourceRequirements" {
  default     = []
  description = "The type and amount of a resource to assign to a container"
  type        = list(string)
}

variable "secrets" {
  default     = []
  description = "The secrets to pass to the container"
  type        = list(map(string))
}

variable "systemControls" {
  default     = []
  description = "A list of namespaced kernel parameters to set in the container"
  type        = list(string)
}

variable "task_role_arn" {
  default     = ""
  description = "The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume"
}

variable "ulimits" {
  default     = []
  description = "A list of ulimits to set in the container"
  type        = list(string)
}

variable "user" {
  default     = ""
  description = "The user name to use inside the container"
}

variable "volumes" {
  default     = []
  description = "A list of volume definitions in JSON format that containers in your task may use"
  type        = list(string)
}

variable "volumesFrom" {
  default     = []
  description = "Data volumes to mount from another container"
  type        = list(string)
}

variable "workingDirectory" {
  default     = ""
  description = "The working directory in which to run commands inside the container"
}

variable "log_driver" {
  default     = "awslogs"
  description = "The log driver to use for the container. Fargate supported log drivers are awslogs and splunk."
}

variable "log_options" {
  default     = {}
  description = "Logging options for the log_driver"
  type        = map(string)
}

# Auto scaling

variable "autoscaling_enabled" {
  default = false
}


variable "metrics_alarms" {
  default     = []
  description = "The list of metrics_alarms autoscaling"
  type = list(object({
    metric_name              = string
    scale_up_threshold       = number
    scale_down_threshold     = number
    evaluation_periods       = number
    comparison_operator_high = string
    comparison_operator_low  = string
    namespace                = string
    period                   = number
    statistic                = string
  }))
}

variable "cpu_low_threshold_percent" {
  default     = "20"
  description = "If the average CPU utilization over a minute drops to this threshold, reduce number of container"
}

variable "cpu_high_threshold_percent" {
  default     = "80"
  description = "If the average CPU utilization over a minute rises to this threshold, increase number of container"
}

variable "autoscale_max_capacity" {
  default = "1"
}

variable "autoscale_min_capacity" {
  default = "1"
}

# Deployment

variable "deployment_controller_type" {
  default     = "ECS"
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS"
}

variable "load_balancer" {
  default     = []
  description = "The list of load balancer"
  type = list(map(string))
}