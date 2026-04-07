terraform {
  required_version = ">= 1.6.0"
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "local" {}

provider "random" {}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}
