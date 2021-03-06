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


variable "project" {
    type        = string
    description = "the GCP project id where the cluster will be created"
}

variable "env" {
    type        = string
    description = "the environment in where the cluster is being created"
}

variable "region" {
    type        = string
    default     = "us-central1"
    description = "the GCP region where the cluster will be created"
}

variable "zone" {
    type        = string
    default     = "us-central1-c"
    description = "the GCP zone in the region where the cluster will be created"
}

variable "network" {
    type = string
    description = "The VPC network to host the cluster in"
}

variable "subnet" {
    type = string
    description = "The subnetwork to host the cluster in"
}

variable "sync_repo" {
    type        = string
    description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
}

variable "sync_branch" {
    type        = string
    description = "the git branch in the repo to sync"
}

variable "policy_dir" {
    type        = string
    description = "the root directory in the repo branch that contains the resources."
}
