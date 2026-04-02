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

## Hands-on Exercises

