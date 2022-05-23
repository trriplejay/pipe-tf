# Required for Terraform 0.13 and up (https://www.terraform.io/upgrade-guides/0-13.html)
terraform {
  required_providers {
    artifactory = {
      source  = "registry.terraform.io/jfrog/artifactory"
      version = "2.20.0"
    }
    project = {
      source  = "registry.terraform.io/jfrog/project"
      version = "1.0.3"
    }
    pipeline = {
      source  = "registry.terraform.io/jfrog/pipeline"
      version = "1.0.0"
    }
  }
}

variable "artifactory_url" {
  type = string
  default = "https://timeoutf8610.jfrogdev.org"
}

provider "artifactory" {
  url = "${var.artifactory_url}"
}

provider "project" {
  url = "${var.artifactory_url}"
}
provider "pipeline" {
  url = "${var.artifactory_url}/pipelines/api/v1"
  access_token = "${var.api_access_token}"
}

variable "qa_roles" {
  type    = list(string)
  default = ["READ_REPOSITORY", "READ_RELEASE_BUNDLE", "READ_BUILD", "READ_SOURCES_PIPELINE", "READ_INTEGRATIONS_PIPELINE", "READ_POOLS_PIPELINE", "TRIGGER_PIPELINE"]
}

variable "devop_roles" {
  type    = list(string)
  default = ["READ_REPOSITORY", "ANNOTATE_REPOSITORY", "DEPLOY_CACHE_REPOSITORY", "DELETE_OVERWRITE_REPOSITORY", "TRIGGER_PIPELINE", "READ_INTEGRATIONS_PIPELINE", "READ_POOLS_PIPELINE", "MANAGE_INTEGRATIONS_PIPELINE", "MANAGE_SOURCES_PIPELINE", "MANAGE_POOLS_PIPELINE", "READ_BUILD", "ANNOTATE_BUILD", "DEPLOY_BUILD", "DELETE_BUILD", ]
}

resource "project" "myproject" {
  key          = "jproj"
  display_name = "Johns project"
  description  = "my project for doing stuff"
  admin_privileges {
    manage_members   = true
    manage_resources = true
    index_resources  = true
  }
  max_storage_in_gibibytes   = 10
  block_deployments_on_limit = false
  email_notification         = true

  member {
    name  = "firstprojectadmin" // Must exist already in Artifactory
    roles = ["Developer", "Project Admin"]
  }

  member {
    name  = "devuser" // Must exist already in Artifactory
    roles = ["Developer"]
  }

  repos = ["example-repo-local"] // Must exist already in Artifactory
}