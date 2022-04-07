# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.ONESHELL:
.SILENT:
.EXPORT_ALL_VARIABLES:
SHELL := /bin/bash

# Source important environmental variables that need to be persisted and are easy to forget about
-include .env.make

vpc-network:
	

# Register an internal TCP/UDP load balancer
forwarding-rule:
	gcloud beta compute forwarding-rules create forwarding-rule-sd  \
		--region=us-central1 \
		--load-balancing-scheme=INTERNAL \
		--network=test-app1-vpc \
		--subnet=test-app1-subnet1 \
		--address=10.0.0.12 \
		--ip-protocol=tcp \
		--ports=80 \
		--backend-service=test-app-ilb \
		--backend-service-region=us-central1 \
		--service-directory-registration=projects/kpt-bootstrap-001/locations/us-central1/namespaces/test-app1/services/test-app1-service

# gcloud beta compute forwarding-rules create $FORWARDING_RULE_NAME  \
# 	--region=$REGION \
# 	--load-balancing-scheme=INTERNAL \
# 	--network=$NETWORK_NAME \
# 	--subnet=$SUBNET_NAME \
# 	--address=$RESERVED_IP_ADDRESS \
# 	--ip-protocol=$PROTOCOL_TYPE \
# 	--ports=$PORT_NUMBER \
# 	--backend-service=$BACKEND_SERVICE_NAME \
# 	--backend-service-region=$REGION \
# 	--service-directory-registration=$SD_SERVICE_NAME		

resolve-service-directory:
	gcloud service-directory services resolve test-app1-service \
	    --namespace=test-app1 \
	    --location=us-central1