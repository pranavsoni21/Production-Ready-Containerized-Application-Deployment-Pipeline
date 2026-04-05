variable "network_mode" {
  type    = string
  default = "awsvpc"
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "iam_role_arn" {
  type = string
}

variable "container_port" {
  type = number
}

variable "ecs_task_cpu" {
  type = number
}

variable "ecs_task_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "security_groups_id" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
