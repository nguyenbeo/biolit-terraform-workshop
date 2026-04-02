terraform {
  required_version = ">= 1.6.0"
}

provider "local" {}

provider "random" {}

resource "random_password" "email_random_password" {
  length = 16
  special = true
}

resource "local_file" "password_file" {
  filename = "./resources/password.txt"
  content  = "Password: ${random_password.email_random_password.result}"
}
