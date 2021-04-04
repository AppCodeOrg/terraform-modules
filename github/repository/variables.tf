variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "description" {
  type        = string
  description = "A description of the repository."
}

variable "is_private_repo" {
  type        = bool
  description = "Set to true to create a private repository. Defaults to true"
  default     = true
}

variable "is_template" {
  type        = bool
  description = "Set to true to tell GitHub that this is a template repository. Defaults to false"
  default     = false
}

variable "allow_merge_commit" {
  type        = bool
  description = "Set to false to disable merge commits on the repository. Defaults to true"
  default     = true
}

variable "allow_rebase_merge" {
  type        = bool
  description = "Set to false to disable rebase merges on the repository. Defaults to false"
  default     = false
}

variable "allow_squash_merge" {
  type        = bool
  description = "Set to false to disable squash merges on the repository. Defaults to false"
  default     = false
}

variable "delete_branch_on_merge" {
  type        = bool
  description = "Automatically delete head branch after a pull request is merged. Defaults to true"
  default     = true
}

variable "archived" {
  type        = bool
  description = "Specifies if the repository should be archived. Defaults to false"
  default     = false
}

variable "create_from_template" {
  type        = bool
  description = "Specifies whether to create the repo from a template repository. Defaults to true and creates from generic template"
  default     = false
}

variable "template" {
  type        = map(string)
  description = "Repository Template. Defaults to generic template"
  default = {
    owner      = "ApplicationCode"
    repository = "github-repository-template"
  }
}

variable "webhook_url" {
  type        = string
  description = "URL of the webhook. Defaults to empty"
  default     = ""
}

variable "webhook_content_type" {
  type        = string
  description = "Webhook Content Type. May be either form or json. Defaults to form"
  default     = "form"
}

variable "branches_to_create" {
  type    = list(string)
  default = []
}

variable "enable_branch_protection" {
  type    = bool
  default = true
}

variable "branches_to_protect" {
  type    = list(string)
  default = []
}

variable "branches_require_pull_request_review" {
  type    = map(bool)
  default = {}
}

variable "master_approving_review_count" {
  type    = number
  default = 1
}

variable "branches_approving_review_count" {
  type        = map(number)
  description = "Key pair values of branch names and required review count"
  default     = {}
}

variable "repository_labels" {
  type = map(string)
  default = {
    "free to merge" = "0e8a16"
    "WIP"           = "fbca04"
    "priority"      = "d93f0b"
  }
}

variable "teams_repository_memberships" {
  type    = map(string)
  default = {}
}

variable "collaborators_repository_memberships" {
  type    = map(string)
  default = {}
}

variable "teams" {
  type    = map(string)
  default = {}
}

variable "deploy_key" {
  type        = string
  description = "Public SSH Deploy Key"
  default     = ""
}
