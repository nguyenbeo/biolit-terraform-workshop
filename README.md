# biolit-terraform-workshop
Terraform Workshop at Biolit

## Intro

* Who has used Terraform before?
* What do you want to get out of this session?
* Who has used kubectl commands?

### What is Terraform?
Terraform is an Infrastructure as Code (IaC) tool created by HashiCorp.

It allows us to define infrastructure using declarative configuration files.

Instead of manually creating resources through a UI or by running ad hoc commands, we describe the desired state in code.

### Why Terraform?
A good way to introduce this is by comparing the “manual way” with Infrastructure as Code.

**Manual approach creating folders and files**
```
project/
  config/
  logs/
  data/
```
Then add files manually. This works for one machine, but problems appear quickly:
* someone forgets one folder
* naming is inconsistent
* different developers set it up differently
* documentation gets outdated

**Terraform Approach**
```
resource "local_file" "config" {
  filename = "config.json"
  content  = "{\"env\":\"dev\"}"
}
```
Now the setup becomes:
* repeatable
* version controlled
* easy to share
* easy to destroy and recreate

## Core Concepts

### Providers
Providers are plugins that know how to talk to a specific platform or system. For example, the local provider ships with Terraform and can manage files on your workstation.
```
terraform {
  required_version = ">= 1.6.0"
}

provider "local" {}
```

### Resources
Resources describe the infrastructure objects you want Terraform to manage. They capture desired state and Terraform converges to it.
```
resource "local_file" "hello" {
  filename = "./resources/hello.txt"
  content  = "Hello from Terraform!"
}
```

### Variables and Outputs
Variables make configurations reusable and parameterized. Outputs expose useful values after a run—great for piping into other automation.
```
variable "name" {
  description = "Who gets the greeting"
  type        = string
  default     = "Biolit"
}

output "welcome" {
  value = "Welcome ${var.name}"
}
```

### State
Terraform keeps track of managed objects in `terraform.tfstate`. Always treat the state file as the source of truth and protect it (use remote state backends for teams). Running `terraform plan` compares the state to your configuration to preview changes before `terraform apply` makes them real.

### Modules
Modules are just directories that bundle variables, resources, and outputs. Use them to share patterns like VPCs or app stacks. Even a single file in this repo (e.g., `1.local_file.tf`) is a root module, and you can call other modules via `module` blocks to standardize infrastructure.

## Hands-on Exercises

## Troubleshooting and Best Practices


## Wrap up
