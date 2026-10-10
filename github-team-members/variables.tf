variable "github_organization" {
  description = "GitHub organization the teams belong to. Set explicitly via terraform.tfvars - no default."
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

variable "team_members" {
  description = <<-EOT
    See nebula/github/team-membership's team_members variable. Keyed by team
    slug/ID (a plain string, not a reference) - this stack is deliberately
    independent of orbit/github and nebula/github/team: it only adds members to
    teams that already exist, it never creates a team itself. Set explicitly via
    terraform.tfvars - no default.
  EOT
  type        = map(map(string))
}
