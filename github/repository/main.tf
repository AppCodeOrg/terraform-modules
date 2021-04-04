locals {
  visibility                           = var.is_private_repo ? "private" : "public"
  default_branch                       = "master"
  branches_to_protect                  = var.enable_branch_protection ? concat(["master"], var.branches_to_protect) : []
  branches_require_pull_request_review = var.enable_branch_protection ? merge({ master = true }, var.branches_require_pull_request_review) : {}
  branches_approving_review_count      = var.enable_branch_protection ? merge({ master = var.master_approving_review_count }, var.branches_approving_review_count) : {}

}

resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  visibility  = local.visibility

  auto_init     = true
  has_issues    = false
  has_projects  = false
  has_wiki      = false
  has_downloads = false

  is_template = var.is_template

  allow_merge_commit = var.allow_merge_commit
  allow_rebase_merge = var.allow_rebase_merge
  allow_squash_merge = var.allow_squash_merge

  delete_branch_on_merge = var.delete_branch_on_merge
  archived               = var.archived

  dynamic "template" {
    for_each = var.create_from_template ? [1] : []
    content {
      owner      = lookup(var.template, "owner")
      repository = lookup(var.template, "repository")
    }
  }

  lifecycle {
    ignore_changes = [auto_init, template]
  }

}

resource "github_repository_webhook" "webhook" {
  count = length(var.webhook_url) > 0 ? 1 : 0

  repository = github_repository.repository.name

  configuration {
    url          = var.webhook_url
    content_type = var.webhook_content_type
    insecure_ssl = false
  }
  active = true
  events = [
    "push",
    "pull_request",
  ]
}

resource "github_branch" "branches" {
  for_each = toset(var.branches_to_create)

  repository    = github_repository.repository.name
  branch        = each.key
  source_branch = local.default_branch
}

resource "github_branch_protection_v3" "branch_protections" {
  for_each = toset(local.branches_to_protect)

  repository     = github_repository.repository.name
  branch         = each.key
  enforce_admins = true

  required_status_checks {
    strict   = true
    contexts = []
  }

  dynamic "required_pull_request_reviews" {
    for_each = lookup(local.branches_require_pull_request_review, each.key, false) ? [1] : []
    content {
      dismiss_stale_reviews           = true
      require_code_owner_reviews      = true
      required_approving_review_count = lookup(local.branches_approving_review_count, each.key, 1)
    }
  }

  lifecycle {
    ignore_changes = [required_status_checks]
  }

  depends_on = [
    github_branch.branches
  ]

}

resource "github_team_repository" "teams_repository_memberships" {
  for_each = var.teams_repository_memberships

  team_id    = lookup(var.teams, each.key)
  repository = github_repository.repository.name
  permission = each.value
}

resource "github_repository_collaborator" "collaborators_repository_memberships" {
  for_each = var.collaborators_repository_memberships

  username   = each.key
  repository = github_repository.repository.name
  permission = each.value
}

resource "github_issue_label" "labels" {
  for_each   = github_repository.repository.archived ? {} : var.repository_labels
  repository = github_repository.repository.name
  name       = each.key
  color      = each.value

  lifecycle {
    ignore_changes = [
      description
    ]
  }
}

resource "github_repository_deploy_key" "repository_deploy_key" {
  count = length(var.deploy_key) > 0 ? 1 : 0

  title      = "Repository deploy key"
  repository = github_repository.repository.name
  key        = var.deploy_key
  read_only  = false
}
