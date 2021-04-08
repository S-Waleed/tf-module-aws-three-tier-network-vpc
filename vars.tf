variable "aws_region" {
  default = "us-east-1"
}

variable "aws_cli_profile" {
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "zones" {
  type    = list(any)
  default = ["a", "b"]
}

variable "vpc_name" {
  type    = string
  default = "sharepoint"

  validation {
    condition     = length(var.vpc_name) > 4
    error_message = "The vpc_name value must contain more than 4 characters."
  }
}

variable "public_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.1.0/28", "10.0.2.0/28"]
}

variable "web_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "app_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.7.0/24", "10.0.8.0/24"]
}

variable "additional_tags" {
  type        = map(any)
  description = "Common tags for every resource"
}

variable "default_security_group_ingress" {
  description = "List of maps of ingress rules to set on the default security group"
  type        = list(map(string))
  default = [
    {
      cidr_blocks = "10.0.0.0/16"
      description = "Allow all from the local network."
      from_port   = 0
      protocol    = "-1"
      self        = false
      to_port     = 0
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all HTTPS from the internet."
      from_port   = 443
      protocol    = "6"
      self        = false
      to_port     = 443
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all HTTP from the internet."
      from_port   = 80
      protocol    = "6"
      self        = false
      to_port     = 80
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all ephemeral ports from the internet."
      from_port   = 32768
      protocol    = "6"
      self        = false
      to_port     = 60999
    }
  ]
}

variable "default_security_group_egress" {
  description = "List of maps of egress rules to set on the default security group"
  type        = list(map(string))
  default = [
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all"
      from_port   = 0
      protocol    = "-1"
      self        = false
      to_port     = 0
    }
  ]
}
