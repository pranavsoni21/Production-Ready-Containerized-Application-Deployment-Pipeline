variable "vpc_id" {
  type = string
}

variable "alb_port" {
  type = number
}

variable "target_type" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "security_group" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}