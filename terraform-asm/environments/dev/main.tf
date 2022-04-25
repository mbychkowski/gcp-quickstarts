locals {
  cluster_type = "simple-zonal-asm"
}

data "google_client_config" "default" {}

provider "google-beta" {
  version = "~> 3.79.0"
  region  = var.region
}

provider "google" {
  version = "~> 3.63.0"
  region  = var.region
}

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
  version                 = "18.0.0"

  project_id              = var.project_id
  name                    = "${local.cluster_type}-cluster-${var.cluster_name_suffix}"
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
  source                = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  version               = "18.0.0"
  asm_version	        = var.asm_version
  cluster_name          = module.gke.name
  project_id            = var.project_id
  location              = module.gke.location
  cluster_endpoint      = module.gke.endpoint
  enable_all            = false
  enable_cluster_roles  = true
  enable_cluster_labels = false
  enable_gcp_apis       = true
  enable_gcp_iam_roles  = true
  enable_gcp_components = true
  enable_registration   = false
  managed_control_plane = false
  service_account       = "${var.terraform_sa}@${var.project_id}.iam.gserviceaccount.com"
  key_file              = "./${var.terraform_sa}.json"
  options               = ["envoy-access-log,egressgateways"]
  custom_overlays       = ["./custom_ingress_gateway.yaml"]
  skip_validation       = false
  outdir                = "./${module.gke.name}-outdir-${var.asm_version}"
  # ca                    = "citadel"
  # ca_certs = {
  #   "ca_cert"    = "./ca-cert.pem"
  #   "ca_key"     = "./ca-key.pem"
  #   "root_cert"  = "./root-cert.pem"
  #   "cert_chain" = "./cert-chain.pem"
  # }
}
