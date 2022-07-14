# terraform-asm

Enable api services if not already

```
gcloud services enable compute.googleapis.com \
    container.googleapis.com
```

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