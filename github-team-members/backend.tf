terraform {
  backend "s3" {
    bucket               = "black-knief-terraform-states"
    key                  = "github-team-members/terraform.tfstate"
    workspace_key_prefix = "ps"
    region               = "us-east-1"
    profile              = "floci"
    encrypt              = true
    use_lockfile         = true
  }
}
