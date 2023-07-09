resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Input URL from Module = ${var.VALUE}"
  }
}
