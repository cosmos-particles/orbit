module "github" {
  source = "../../constellation/github"

  teams        = var.teams
  repositories = var.repositories
}
