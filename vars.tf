variable aws_region {
  default = "us-east-1"
}

variable aws_cli_profile {
}

variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable zones {
  type = list
  default = ["a", "b"]
}

variable vpc_name {
  type = string
  default = "sharepoint"

  validation {
    condition     = length(var.vpc_name) > 4
    error_message = "The vpc_name value must contain more than 4 characters."
  }
}

variable public_subnet_cidrs {
  type = list
  default = ["10.0.1.0/28", "10.0.2.0/28"]
}

variable web_subnet_cidrs {
  type = list
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable app_subnet_cidrs {
  type = list
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable data_subnet_cidrs {
  type = list
  default = ["10.0.7.0/24", "10.0.8.0/24"]
}

variable additional_tags {
  type = map
  description = "Common tags for every resource"
}
