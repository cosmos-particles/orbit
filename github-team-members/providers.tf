# Authenticates as a GitHub App installation. Each app_auth field falls back to
# its matching GITHUB_APP_* env var when the corresponding variable is null, so
# the recommended way to run this is still via env vars - set the variables
# only if you need a value that differs across runs/environments.
provider "github" {
  owner = var.github_organization
  app_auth {
    id              = var.app_id              # or `GITHUB_APP_ID`
    installation_id = var.app_installation_id # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = var.app_pem_file        # or `GITHUB_APP_PEM_FILE`
  }
}
