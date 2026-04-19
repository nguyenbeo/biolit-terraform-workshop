# https://registry.terraform.io/providers/hashicorp/random/latest/docs
resource "random_password" "email_random_password" {
  length  = 16
  special = true
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs
resource "local_file" "password_file" {
  filename = "${path.root}/resources/password.txt"
  content  = "Password: ${random_password.email_random_password.result}"
}
