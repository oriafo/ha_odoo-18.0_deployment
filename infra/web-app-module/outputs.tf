output "instance_pub_ips" {
  value = aws_autoscaling_group.custom_asg.instances[*].public_ip
}

output "db_instance_addr" {
  value = aws_db_instance.db_instance.address
}

# Output the custom VPC
output "vpc_custom_vpc" {
  value = aws_vpc.custom_vpc.id
}

# Output the dns_name of the load balancer
output "custom_lb" {
  description = "Return the dns name of the load balancer, we can use to access our instances"
  value       = aws_lb.custom_lb.dns_name
}

# Output the public IP
output "public_ip" {
  value = data.http.public_ip.body
}