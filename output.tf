output "application_url" {
  value = "http://${aws_instance.app_server.public_ip}:8080"
}
output "app_server_public_ip"{
    value = aws_instance.app_server.public_ip
}