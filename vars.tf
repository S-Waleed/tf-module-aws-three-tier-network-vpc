variable vpc_cidr {
  type = string
  default = "10.0.0.0/16"
}

variable public_zone_a_subnet_cidr {
  type = string
  default = "10.0.1.0/28"
}

variable public_zone_b_subnet_cidr {
  type = string
  default = "10.0.2.0/28"
}

variable web_zone_a_subnet_cidr {
  type = string
  default = "10.0.3.0/24"
}

variable web_zone_b_subnet_cidr {
  type = string
  default = "10.0.4.0/24"
}

variable app_zone_a_subnet_cidr {
  type = string
  default = "10.0.5.0/24"
}

variable app_zone_b_subnet_cidr {
  type = string
  default = "10.0.6.0/24"
}

variable data_zone_a_subnet_cidr {
  type = string
  default = "10.0.7.0/24"
}

variable data_zone_b_subnet_cidr {
  type = string
  default = "10.0.8.0/24"
}

variable vpc_name {
  type = string

  validation {
    condition     = length(var.policy_description) > 4
    error_message = "The vpc_name value must contain more than 4 characters."
  }
}

variable additional_tags {
  type = map
  description = "Common tags for every resource"
}
