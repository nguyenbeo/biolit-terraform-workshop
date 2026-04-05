module "dev_config" {
  source = "./modules/config_files"
  environment = "dev"
  message = "Development configuration"
}
