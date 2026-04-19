# for_each and count are meta arguments class of arguments built into the Terraform 
# configuration language that  control how Terraform creates and manages your infrastructure. 
# You can use meta-arguments in any type of resource
# https://developer.hashicorp.com/terraform/language/meta-arguments
resource "local_file" "notes" {
  count    = 3
  filename = "${path.module}/resources/note-${count.index}.txt"
  content  = "File ${count.index}"
}

resource "local_file" "password_files" {
  for_each = toset(["dev", "stage", "prod"])

  filename = "${path.module}/resources/${each.key}.txt"
  content  = each.key
}
