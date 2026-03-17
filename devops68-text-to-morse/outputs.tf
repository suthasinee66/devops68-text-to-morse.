output "app_public_url" {
  value = "http://${aws_instance.nodejs_server.public_ip}:${var.app_port}"
  description = "Copy URL นี้ไปเปิดใน Browser"
}