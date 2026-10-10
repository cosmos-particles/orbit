variable "github_organization" {
  description = "GitHub organization that owns the cosmos repos. Set explicitly via terraform.tfvars - no default."
  type        = string
}

variable "app_id" {
  description = "GitHub App ID used to authenticate the github provider. Optional - falls back to the GITHUB_APP_ID env var when null."
  type        = string
  default     = null
}

variable "app_installation_id" {
  description = "GitHub App installation ID used to authenticate the github provider. Optional - falls back to the GITHUB_APP_INSTALLATION_ID env var when null."
  type        = string
  default     = null
}

variable "app_pem_file" {
  description = "GitHub App private key, as raw PEM contents (not a file path) used to authenticate the github provider. Optional - falls back to the GITHUB_APP_PEM_FILE env var when null."
  type        = string
  default     = null
  sensitive   = true
}

variable "teams" {
  description = "See nebula/github/org's teams variable. Set explicitly via terraform.tfvars - no default."
  type        = any
}

variable "repositories" {
  description = <<-EOT
    Map of repo name => config, created under github_organization. Repo names are purely
    data here (map keys) - add/remove/rename a repo by editing terraform.tfvars,
    no .tf changes needed.

    Do NOT set push_initial_content here - orbit/github/main.tf derives it
    automatically as "<cosmos workspace root>/<repo name>" for every entry.
  EOT
  type = map(object({
    description    = optional(string)
    visibility     = optional(string, "private")
    topics         = optional(list(string), [])
    default_branch = optional(string, "main")
    team_access    = optional(map(string), {})
    collaborators  = optional(map(string), {})
    branch_protection = optional(object({
      pattern                         = optional(string, "main")
      required_approving_review_count = optional(number, 1)
      require_code_owner_reviews      = optional(bool, false)
      required_status_checks          = optional(list(string), [])
      enforce_admins                  = optional(bool, false)
      require_conversation_resolution = optional(bool, true)
    }))
  }))
}
