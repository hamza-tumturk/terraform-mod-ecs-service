# terraform-mod-ecs-service

This Terraform module provides an ECS Fargate service.

## Inputs

### aws_ecs_task_definition

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| command | The command that is passed to the container | list | `[]` | no |
| cpu | The number of cpu units reserved for the container | string | `"0"` | no |
| disableNetworking | When this parameter is true, networking is disabled within the container | string | `"false"` | no |
| dnsSearchDomains | A list of DNS search domains that are presented to the container | list | `[]` | no |
| dnsServers | A list of DNS servers that are presented to the container | list | `[]` | no |
| dockerLabels | A key/value map of labels to add to the container | map | `{}` | no |
| dockerSecurityOptions | A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems | list | `[]` | no |
| entryPoint | The entry point that is passed to the container | list | `[]` | no |
| environment_variables | The environment variables to pass to a container | list | `[]` | no |
| essential | If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped | string | `"true"` | no |
| execution\_role\_arn | The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume | string | `""` | no |
| extraHosts | A list of hostnames and IP address mappings to append to the /etc/hosts file on the container | list | `[]` | no |
| healthCheck | The health check command and associated configuration parameters for the container | map | `{}` | no |
| hostname | The hostname to use for your container | string | `""` | no |
| image | The image used to start a container | string | `""` | no |
| interactive | When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated | string | `"false"` | no |
| links | The link parameter allows containers to communicate with each other without the need for port mappings | list | `[]` | no |
| linuxParameters | Linux-specific modifications that are applied to the container, such as Linux KernelCapabilities | map | `{}` | no |
| log_driver | The log driver to use for the container. Fargate supported log drivers are awslogs and splunk. | string | `awslogs` | no |
| log_options | Logging options for the `log_driver` | list | []] | no |
| load_balancer | Load balancer definitions | list | []] | no |
| memory | The hard limit (in MiB) of memory to present to the container | string | `"0"` | no |
| memoryReservation | The soft limit (in MiB) of memory to reserve for the container | string | `"0"` | no |
| mountPoints | The mount points for data volumes in your container | list | `[]` | no |
| name | The name of a container | string | `""` | no |
| network\_mode | The Docker networking mode to use for the containers in the task | string | `"bridge"` | no |
| placement\_constraints | An array of placement constraint objects to use for the task | list | `[]` | no |
| portMappings | The list of port mappings for the container | list | `[]` | no |
| privileged | When this parameter is true, the container is given elevated privileges on the host container instance (similar to the root user) | string | `"false"` | no |
| pseudoTerminal | When this parameter is true, a TTY is allocated | string | `"false"` | no |
| readonlyRootFilesystem | When this parameter is true, the container is given read-only access to its root file system | string | `"false"` | no |
| register\_task\_definition | Registers a new task definition from the supplied family and containerDefinitions | string | `"true"` | no |
| repositoryCredentials | The private repository authentication credentials to use | map | `{}` | no |
| requires\_compatibilities | The launch type required by the task | list | `[]` | no |
| resourceRequirements | The type and amount of a resource to assign to a container | list | `[]` | no |
| secrets | The secrets to pass to the container | list | `[]` | no |
| systemControls | A list of namespaced kernel parameters to set in the container | list | `[]` | no |
| tags | The metadata that you apply to the task definition to help you categorize and organize them | map | `{}` | no |
| task\_role\_arn | The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume | string | `""` | no |
| ulimits | A list of ulimits to set in the container | list | `[]` | no |
| user | The user name to use inside the container | string | `""` | no |
| volumes | A list of volume definitions in JSON format that containers in your task may use | list | `[]` | no |
| volumesFrom | Data volumes to mount from another container | list | `[]` | no |
| workingDirectory | The working directory in which to run commands inside the container | string | `""` | no |

### aws_ecs_service
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| service_name | The name of the service | string | `""` | yes |
| desired_count | The number of instances of the task definition to place and keep running. | int | `1` | no |
| subnet_ids | The subnets associated with the task or service | list | `[]` | yes |
| security_groups | The security groups associated with the task or service. Undefined defaults to security group of the VPC. | list | `""` | no |
| assign_public_ip | Assign a public IP address to the ENI (Fargate launch type only) | bool | `false` | no |

## aws_codedeploy_deployment_group
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| deployment_controller_type | Type of deployment controller. Valid values: CODE_DEPLOY, ECS | string | `ECS` | no |

### aws_appautoscaling
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| autoscaling_enabled | Enable/Disable autoscaling | bool | `false` | no |
| cpu_low_threshold_percent | If the average CPU utilization over a minute drops to this threshold, reduce number of container | int | `20` | no |
| cpu_high_threshold_percent | If the average CPU utilization over a minute rises to this threshold, increase number of container | int | `80` | yes |
| autoscale_max_capacity | The max autoscaling capacity of the ECS service. | int | `1` | no |
| autoscale_min_capacity | The min autoscaling capacity of the ECS service. | int | `1` | no |
