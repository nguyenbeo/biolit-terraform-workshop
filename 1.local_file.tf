terraform {
  required_version = ">= 1.6.0"
}

provider "local" {}

resource "local_file" "hello" {
  filename = "./resources/hello.txt"
  content  = "Hello world"
}
