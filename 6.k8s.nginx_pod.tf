resource "kubernetes_pod_v1" "nginx" {
  metadata {
    name      = "nginx-demo"
    namespace = kubernetes_namespace_v1.name.metadata[0].name
    labels = {
      app = "nginx"
    }
  }

  spec {
    container {
      name  = "nginx"
      image = "nginx:1.25-alpine"

      port {
        container_port = 80
        name           = "http"
      }

      resources {
        limits = {
          cpu    = "250m"
          memory = "128Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "64Mi"
        }
      }
    }

    restart_policy = "Always"
  }
}
