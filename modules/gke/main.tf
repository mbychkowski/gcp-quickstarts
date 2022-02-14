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


 module "gke" {
    source             = "terraform-google-modules/kubernetes-engine/google"
    version            = "~> 16.0"
    project_id         = var.project
    name               = "sfl-acm"
    region             = var.region
    zones              = [var.zone]
    initial_node_count = 4
    network            = var.network
    subnetwork         = var.subnet
    ip_range_pods      = "${var.env}-pod"
    ip_range_services  = "${var.env}-svc"

    node_pools = [
        {
            name         = "pool-01"
            machine_type = "e2-standard-2"
            auto_repair  = true
            auto_upgrade = true
            enable_secure_boot = true
            enable_integrity_monitoring = true
            enable_shielded_nodes = true
        }
    ]

}

resource "google_gke_hub_membership" "membership" {
  provider      = google-beta
  membership_id = "membership-hub-${module.gke.name}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
}

resource "google_gke_hub_feature" "configmanagement_acm_feature" {
  name     = "configmanagement"
  location = "global"
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "feature_member" {
  provider   = google-beta
  location   = "global"
  feature    = "configmanagement"
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.8.0"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo   = var.sync_repo
        sync_branch = var.sync_branch
        policy_dir  = var.policy_dir
        secret_type = "none"
      }
    }
  }
  depends_on = [
    google_gke_hub_feature.configmanagement_acm_feature
  ]
}
