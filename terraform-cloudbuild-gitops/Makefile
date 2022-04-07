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


authenticate: 
	@gcloud auth login --brief --update-adc --quiet
	@gcloud auth application-default print-access-token > access-token-file.txt

create-project: 
  # Create a GCP landing zone project
	@gcloud projects create ${PROJECT_ID} --organization=${ORGANIZATION_ID} --set-as-default ${access-token-file.txt}
	@gcloud beta billing projects link ${PROJECT_ID} --billing-account=${BILLING_ACCOUNT_ID} ${access-token-file.txt}
	@gcloud config set project ${PROJECT_ID}

create-gcs-state-store:
	@gsutil mb gs://${PROJECT_ID}-tfstate
	@gsutil versioning set on gs://${PROJECT_ID}-tfstate

enable-apis: 
	@gcloud --project ${PROJECT_ID} services enable \
		cloudresourcemanager.googleapis.com \
		container.googleapis.com \
		krmapihosting.googleapis.com \
		monitoring.googleapis.com \
		cloudasset.googleapis.com \
		secretmanager.googleapis.com \
		cloudbuild.googleapis.com \
		orgpolicy.googleapis.com \
		sourcerepo.googleapis.com
		
assign-super-user-permissions: enable-apis
	# Assign Org and Project-level IAM permissions to your Argolis super-user
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="user:${GCP_SUPER_USER}" --role="roles/resourcemanager.organizationAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="user:${GCP_SUPER_USER}" --role="roles/orgpolicy.policyAdmin" ${access-token-file.txt}
	# Assign Org and Project-level IAM permissions to your Argolis Org's GCP Workspace 'admin-group' and 'billing-admin-group'
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/resourcemanager.organizationAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/orgpolicy.policyAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/resourcemanager.folderAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/owner" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/resourcemanager.projectCreator" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_ORGANIZATION_ADMIN}" --role="roles/compute.xpnAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="group:${GCP_BILLING_ADMIN}" --role="roles/billing.admin" ${access-token-file.txt}
	# Bind IAM permissions to the default Cloud Build service account
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" --role=roles/owner
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" --role=roles/billing.user
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" --role=roles/resourcemanager.folderAdmin
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" --role=roles/resourcemanager.organizationAdmin	

.PHONY: replace-project-id
replace-project-id:
	@sed -i s/PROJECT_ID/${PROJECT_ID}/g environments/${ENV}/terraform.tfvars
	@sed -i s/PROJECT_ID/${PROJECT_ID}/g environments/${ENV}/backend.tf