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
