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
Variables make configurations reusable and parameterized. Outputs expose useful values after a run - great for piping into other automation.
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

1. **Bootstrap Terraform locally** - Review the configured providers in `0.providers.tf` and run `terraform init` followed by `terraform fmt` + `terraform validate` so you start from a clean, initialized workspace. Skim the generated `.terraform.lock.hcl` to see which plugins (local, random, kubernetes) are pulled in.
2. **Generate a secure password file** - Apply just the resources in `1.local_file.tf` (`terraform apply -target=random_password.email_random_password -target=local_file.password_file`) and then inspect `resources/password.txt` to confirm interpolation works. Delete the file and re-apply to observe how Terraform detects drift.
3. **Customize variables and outputs** - In `2.variables_outputs.tf`, override `name`, `environment`, and `team` via `terraform.tfvars` or CLI `-var` flags, then `terraform apply`. Use `terraform output` afterward to capture the rendered welcome text and the generated file path.
4. **Practice count vs. for_each** - Apply `3.for_each.tf` and compare the resources created by `count` vs. `for_each`. Try adding another environment to the `toset` call, run `terraform plan`, and observe how Terraform only touches the delta.
5. **Call a reusable module** - Inspect `4.modules.tf` along with `modules/config_files/*` to see how module inputs/outputs map together. `terraform apply -target=module.dev_config` first, then remove the target to provision every environment (`dev`, `staging`, `production`). Check the generated files under `resources/`.
6. **Create a Kubernetes namespace** - Ensure your kubeconfig context matches `docker-desktop`, then apply `5.k8s.namespace.tf`. Verify the namespace exists with `kubectl get ns biolit`.
7. **Deploy the sample NGINX workload** - Apply `6.k8s.nginx_pod.tf` to create the `nginx-demo` deployment. Use `kubectl get deploy -n biolit` and `kubectl describe deploy/nginx-demo -n biolit` to inspect the replica set, pods, container image, and resource requests.
8. **Expose and test the service** - Apply `7.k8s.expose_service.tf` to provision the `ClusterIP` service, then run `kubectl port-forward svc/nginx-demo -n biolit 8080:80` and curl `http://localhost:8080` to validate traffic reaches the pods. Clean up everything with `terraform destroy` when finished.
9. **Catch Kubernetes drift** - After the NGINX deployment exists, manually scale it out-of-band with `kubectl scale deployment/nginx-demo -n biolit --replicas=6`. Use `kubectl get deploy nginx-demo -n biolit` to confirm the drift, then run `terraform plan -target=kubernetes_deployment_v1.nginx` to see Terraform propose resetting replicas to the declared count. Finish by either applying the plan or scaling the deployment back yourself so state and cluster realign.
10. **Tear everything down safely** - List current resources via `terraform state list`, run `terraform destroy`, and review the plan before typing `yes`. Once the destroy completes, double-check with `kubectl get all -n biolit` and inspect the `resources/` folder to verify nothing managed remains, then run a final `terraform plan` to ensure the workspace reports no changes.

## Troubleshooting and Best Practices

- **Start clean**: When Terraform acts strangely, remove any half-finished state with `terraform destroy -target=...` or re-run `terraform init -upgrade` to refresh providers before retrying.
- **Lock state early**: Even in a workshop, store `terraform.tfstate` remotely (S3 + DynamoDB lock, Terraform Cloud, etc.) as soon as more than one person applies changes to avoid accidental overwrites.
- **Validate continuously**: Run `terraform fmt`, `terraform validate`, and `terraform plan` before `apply` so syntax errors or drift surface locally rather than while provisioning real infrastructure.
- **Secrets hygiene**: Never commit `terraform.tfstate`, `.terraform/`, or generated files in `resources/` that might hold secrets such as `password.txt`. Add them to `.gitignore` and use Vault/Secrets Manager for production.
- **Kubernetes context checks**: Confirm `kubectl config current-context` points at the intended cluster before applying the Kubernetes resources. Use distinct namespaces (like `biolit`) plus labels to simplify cleanup.
- **Iterate with targets sparingly**: `-target` is helpful for demos but hides dependencies; once experimentation is done, remove targets and run a full `terraform apply` to ensure you capture the real graph.
- **Observe drift**: Regularly inspect outputs (`terraform output`) and the cluster (`kubectl get all -n biolit`) to verify Terraform’s desired state matches reality, then reconcile via `terraform apply` or `destroy`.
- **Keep modules minimal**: Version your modules (`source = \"./modules/config_files\"` → `source = \"git::...//config_files?ref=v1\"`) and document their inputs/outputs so other teams can reuse them confidently.

## Wrap up

- Terraform lifecycle in this repo moves from local resources to Kubernetes, so every exercise reinforces init → plan → apply → drift detection → destroy with the same workflow.
- Desired state wins: when we edit files or scale deployments manually, `terraform plan` exposes drift and `terraform apply` reconciles code and reality.
- Kubernetes fits naturally once kubeconfig is set namespaces, deployments, and services behave just like any other Terraform-managed objects.
- Good hygiene (fmt/validate, state inspections, verify-destroy) keeps experiments safe and transfers directly to production teams.

**Q&A Prompts**
- How would you migrate this workshop to a remote backend (Terraform Cloud, S3 + DynamoDB) so teams can collaborate safely?
- What alerts or policies would catch a manual `kubectl scale` before Terraform runs again?
- Which module interfaces here (`modules/config_files`) would you document or version before sharing internally?
- What provider swaps (AWS, Azure) would you make to reuse these exercises in your own environment?
