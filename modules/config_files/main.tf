resource "local_file" "config" {
  filename = "${var.environment}-config.txt"
  content  = var.message
}
