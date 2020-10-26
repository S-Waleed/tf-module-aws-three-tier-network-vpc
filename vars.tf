variable ec2_iam_role_name {
  type = string

  validation {
    condition     = length(var.ec2_iam_role_name) > 4 && substr(var.ec2_iam_role_name, 0, 4) == "svc-"
    error_message = "The ec2_iam_role_name value must be a valid IAM role name, starting with \"svc-\"."
  }
}

variable policy_description {
  type = string

  validation {
    condition     = length(var.policy_description) > 4
    error_message = "The policy_description value must contain more than 4 characters."
  }
}

variable assume_role_policy {}

variable policy {}
