SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Source important environmental variables that need to be persisted and are easy to forget about
-include .env.make
-include .hack/vpc/Makefile
-include .hack/gke/Makefile

authenticate:
	@gcloud auth login --brief --update-adc --quiet
	@gcloud auth application-default print-access-token > access-token-file.txt

create-project: 
  # Create a GCP landing zone project
	@gcloud projects create ${PROJECT_ID} --organization=${ORGANIZATION_ID} --set-as-default ${access-token-file.txt}
	@gcloud beta billing projects link ${PROJECT_ID} --billing-account=${BILLING_ACCOUNT_ID} ${access-token-file.txt}
	@gcloud config set project ${PROJECT_ID}

cluster: network k8s-admin-vm gke-private-cluster
	@echo "Making private GKE cluster"

# One time landing zone setup
super-user:
	# Assign Org and Project-level IAM permissions to your Argolis super-user
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="user:${GCP_SUPER_USER}" --role="roles/resourcemanager.organizationAdmin" ${access-token-file.txt}
	@gcloud organizations add-iam-policy-binding ${ORGANIZATION_ID} --condition=None --member="user:${GCP_SUPER_USER}" --role="roles/orgpolicy.policyAdmin" ${access-token-file.txt}	

enable-apis: 
	@gcloud --project ${PROJECT_ID} services enable \
		cloudbuild.googleapis.com \
		krmapihosting.googleapis.com \
		container.googleapis.com \
		cloudresourcemanager.googleapis.com \
		secretmanager.googleapis.com \
		orgpolicy.googleapis.com \
		sourcerepo.googleapis.com
