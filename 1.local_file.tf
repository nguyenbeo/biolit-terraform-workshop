resource "random_password" "email_random_password" {
  length  = 16
  special = true
}

resource "local_file" "password_file" {
  filename = "${path.module}password.txt"
  content  = "Password: ${random_password.email_random_password.result}"
}
