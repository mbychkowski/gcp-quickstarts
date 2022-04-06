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


module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"

    project_id   = "${var.project}"
    network_name = "${var.env}-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name             = "${var.env}-subnet-gke"
            subnet_ip               = "10.0.0.0/28"
            subnet_region           = "${var.region}"
            subnet_private_access   = "true"
            subnet_flow_logs        = "true"
        },
        {
            subnet_name             = "${var.env}-subnet-vm"
            subnet_ip               = "10.0.1.0/28"
            subnet_region           = "${var.region}"
            subnet_private_access   = "true"
            subnet_flow_logs        = "true"
        }
    ]

    secondary_ranges = {
        "${var.env}-subnet-gke" = [
            {
                range_name    = "${var.env}-pod"
                ip_cidr_range = "172.16.0.0/20"
            },
            {
                range_name    = "${var.env}-svc"
                ip_cidr_range = "192.168.64.0/25"                
            }
        ]
  }
}
