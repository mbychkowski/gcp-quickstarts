# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
    network = "${element(split("-", var.subnet), 0)}"
}

resource "google_compute_firewall" "allow-ssh" {
    name    = "${local.network}-allow-ssh"
    network = "${local.network}-vpc"
    project = var.project

    allow {
        protocol = "tcp"
        ports    = ["22", "3389"]
    }

    allow {
        protocol = "icmp"
    }

    target_tags   = ["ssh-iap"]
    source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_router" "router" {
    name    = "${local.network}-router-vm"
    network = "${local.network}-vpc"
    region  = var.region
}

resource "google_compute_router_nat" "nat" {
    name                               = "${local.network}-outer-nat"
    router                             = google_compute_router.router.name
    region                             = "${var.region}"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    
    subnetwork {
        name                    = "${var.env}-subnet-vm"
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }

    subnetwork  {
        name                    = "${var.env}-subnet-gke"
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]            
    }

    log_config {
        enable = true
        filter = "ERRORS_ONLY"
    }
}