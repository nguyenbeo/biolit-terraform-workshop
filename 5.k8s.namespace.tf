resource "kubernetes_namespace_v1" "name" {
  metadata {
    name = "biolit"
  }
}
