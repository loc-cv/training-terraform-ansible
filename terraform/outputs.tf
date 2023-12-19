output "web_instance_ip" {
  value = aws_instance.web_instance.public_ip
}

output "private_key_file" {
  value = local_file.private_key.filename
}
