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
  description = <<-EOT
    See nebula/github/team's teams variable. Creates teams only, with no members -
    see the separate orbit/github-team-members stack to add members once a team
    exists. Set explicitly via terraform.tfvars - no default.
  EOT
  type        = any
}

variable "repositories" {
  description = <<-EOT
    Map of repo name => config, created under github_organization. Repo names are purely
    data here (map keys) - add/remove/rename a repo by editing terraform.tfvars,
    no .tf changes needed.
  EOT
  type = map(object({
    description    = optional(string)
    visibility     = optional(string, "public")
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
      # Actors allowed to push directly to the branch - user: "/<username>",
      # team: "<org>/<team-slug>" (e.g. "cosmos-particles/platform").
      restrict_pushes = optional(list(string), [])
      # Actors allowed to bypass the force-push restriction (same format). Non-empty
      # forces allows_force_pushes to false - force pushes become bypassers-only.
      force_push_bypassers = optional(list(string), [])
    }))
  }))
}
