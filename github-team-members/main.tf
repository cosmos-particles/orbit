# Deliberately not routed through constellation/ - this stack wires up a single
# nebula module with no composition logic of its own, so an extra aggregator
# layer would add nothing. See CLAUDE.md for the full rationale.

module "team_membership" {
  source = "../../nebula/github/team-membership"

  team_members = var.team_members
}
