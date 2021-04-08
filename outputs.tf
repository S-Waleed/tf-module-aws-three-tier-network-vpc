output "default_security_group_id" {
  value = aws_vpc.this.default_security_group_id
}

output "default_network_acl_id" {
  value = aws_vpc.this.default_network_acl_id
}
