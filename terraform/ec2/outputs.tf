output "public_ip" {
  value = aws_instance.resource_machine[*].public_ip
}

output "public_dns" {
  value = aws_instance.resource_machine[*].public_dns
}