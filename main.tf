/**
 * # AWS EKS Registry Cache Terraform module
 *
 * A Terraform module to deploy the registry-cache on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-registry-cache/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-registry-cache/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-registry-cache/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-registry-cache/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "registry-cache"

    helm_chart_name    = "docker-registry"
    helm_chart_version = "2.2.3"
    helm_repo_url      = "https://lablabs.github.io/docker-registry.helm"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })

  addon_depends_on = []
}
