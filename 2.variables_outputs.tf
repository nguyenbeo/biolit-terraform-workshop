variable "name" {
  description = "Person we greet in workshop demos"
  type        = string
  default     = "Biolit"
}

variable "environment" {
  description = "Environment label to show interpolation"
  type        = string
  default     = "dev"
}

variable "team" {
  description = "Team requesting the file"
  type        = string
  default     = "platform"
}

resource "local_file" "welcome_note" {
  filename = "${path.module}/resources/welcome-${var.environment}.txt"
  content  = <<EOT
Welcome ${var.name}!
You're working in the ${var.environment} environment with team ${var.team}.
Generated at ${timestamp()}
EOT
}

output "welcome_message" {
  description = "Final rendered greeting text"
  value       = "Welcome ${var.name} to ${var.environment} (${var.team})"
}

output "welcome_file_path" {
  description = "Shows interpolation referencing resource attributes"
  value       = local_file.welcome_note.filename
}
