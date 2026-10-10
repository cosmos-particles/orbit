locals {
  # cosmos workspace root: orbit/github -> orbit -> cosmos.
  cosmos_root = abspath("${path.root}/../..")

  # Every repo pushes its initial content from the same-named directory at the
  # cosmos workspace root - derived here so terraform.tfvars never has to know
  # the local filesystem layout, only the repo names themselves.
  repositories = {
    for name, repo in var.repositories : name => merge(repo, {
      push_initial_content = {
        source_path = "${local.cosmos_root}/${name}"
      }
    })
  }
}

module "github" {
  source = "../../constellation/github"

  teams        = var.teams
  repositories = local.repositories
}
