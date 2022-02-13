/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.73.0"
    }
  }
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

locals {
    env = "dev"
}

module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id                  = var.project
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
	"krmapihosting.googleapis.com",
	"monitoring.googleapis.com",
	"cloudasset.googleapis.com",
	"secretmanager.googleapis.com",
	"cloudbuild.googleapis.com",
	"orgpolicy.googleapis.com"
  ]
}

module "vpc" {
    source  = "../../modules/vpc"
    project = var.project
    region  = var.region
    env     = local.env
}

module "firewall" {
    source  = "../../modules/firewall"
    project = var.project
    subnet  = module.vpc.subnet
    region  = var.region
    env     = local.env
}

module "gke" {
    source       = "../../modules/gke"
    project      = var.project
    region       = var.region
    zone         = var.zone
    network      = module.vpc.network
    subnet       = module.vpc.subnet
    secondary_ip_ranges = module.vpc.secondary_ip_ranges
    # ip_range_pod = module.vpc.ip_range_pod
    # ip_range_svc = module.vpc.ip_range_svc
    sync_repo    = var.sync_repo
    sync_branch  = var.sync_branch
    policy_dir   = var.policy_dir
}
