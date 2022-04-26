# terraform-asm

```
. .env
```

```
gcloud --project=${PROJECT_ID} iam service-accounts create ${TERRAFORM_SA} \
  --description="terraform-sa" \
  --display-name=${TERRAFORM_SA}
```

```
ROLES=(
  'roles/servicemanagement.admin' \
  'roles/storage.admin' \
  'roles/serviceusage.serviceUsageAdmin' \
  'roles/meshconfig.admin' \
  'roles/compute.admin' \
  'roles/container.admin' \
  'roles/resourcemanager.projectIamAdmin' \
  'roles/iam.serviceAccountAdmin' \
  'roles/iam.serviceAccountUser' \
  'roles/iam.serviceAccountKeyAdmin' \
  'roles/gkehub.admin')
for role in "${ROLES[@]}"
do
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:${TERRAFORM_SA}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="$role"
done
```

```
gsutil mb -p ${PROJECT_ID} gs://${PROJECT_ID}

gsutil versioning set on gs://${PROJECT_ID}
```

```
cat <<'EOF' > backend.tf
terraform {
  backend "gcs" {
    bucket  = "${PROJECT_ID}"
    prefix  = "tfstate"
  }
}
EOF
```

```
export CLUSTER_NAME=$(gcloud container clusters list --format="value(name.scope())")

asmcli install \
  <!-- --kubeconfig ~/.kube/config \ -->
  --project_id ${PROJECT_ID} \
  --cluster_name ${CLUSTER_NAME} \
  --cluster_location ${CLUSTER_LOC} \
  --fleet_id ${PROJECT_ID} \
  --output_dir ${WORKDIR} \
  --enable_all \
  --ca mesh_ca
```