terraform {
  required_version = "~> 0.14"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.6"
    }
  }
}

provider "github" {
  owner = "AppCodeOrg"
}

module "github-terraform-test" {
  source = "../repository"

  name                     = "github-terraform-test"
  description              = "Github Terraform Recipes"
  is_private_repo          = false
  enable_branch_protection = true
  allow_squash_merge       = true

  branches_required_status_checks = {master = ["Trigger-to-run-TF-plan-for-a-PR (aggarwalmayank-com-cloudbuild)"]}
}
