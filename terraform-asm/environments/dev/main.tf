locals {
  cluster_type = "simple-zonal-asm"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_project" "project" {
  project_id = var.project_id
}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google"
  version                 = "19.0.0"

  project_id              = var.project_id
  name                    = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                = false
  region                  = var.region
  zones                   = var.zones
  release_channel         = "REGULAR"
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  network_policy          = false
  cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }
  node_pools = [
    {
      name         = "asm-node-pool"
      autoscaling  = false
      auto_upgrade = true
      # ASM requires minimum 4 nodes and e2-standard-4
      node_count   = 4
      machine_type = "e2-standard-4"
    },
  ]
}

module "asm" {
  source                    = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  version                   = "19.0.0"

  cluster_name              = module.gke.name
  project_id                = var.project_id
  location                  = module.gke.location
  cluster_endpoint          = module.gke.endpoint
}
