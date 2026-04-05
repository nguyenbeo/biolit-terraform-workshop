module "dev_config" {
  source      = "./modules/config_files"
  environment = "dev"
  message     = "Development configuration"
}

module "env_configs" {
  for_each    = toset(["staging", "production"])
  source      = "./modules/config_files"
  environment = each.key
  message     = "Env ${each.key} configuration"
}
