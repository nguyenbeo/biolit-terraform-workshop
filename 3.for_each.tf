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
