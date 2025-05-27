output "instance_public_ip" {
  description = "Public IP of the deployed EC2 instance"
  value       = aws_instance.web_server.public_ip
}
