output "Web_IP" {
  value = [aws_instance.web-server.public_ip]
}