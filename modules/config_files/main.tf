resource "local_file" "config" {
  filename = "${path.root}/resources/${var.environment}-config.txt"
  content  = var.message
}
