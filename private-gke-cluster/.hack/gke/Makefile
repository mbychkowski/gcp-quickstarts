# Source important environmental variables that need to be persisted and are easy to forget about
-include .env.make

gke-private-cluster:
	@gcloud container clusters create tmp-cluster-2 \
  		--enable-ip-alias \
  		--enable-private-nodes \
		--enable-private-endpoint \
		--enable-shielded-nodes \
		--image-type=cos_containerd \
		--machine-type=e2-standard-2 \
  		--zone=us-central1-a \
		--network=tmp-net \
		--subnetwork=tmp-subnet \
		--cluster-secondary-range-name=po \
		--services-secondary-range-name=svc \
  		--master-ipv4-cidr=10.4.0.0/28 \
		--enable-master-authorized-networks \
    	--master-authorized-networks=10.0.0.0/28,10.0.1.2/32 \
		--workload-pool=${PROJECT_ID}.svc.id.goog \
		--service-account=config-sync-sa@${PROJECT_ID}.iam.gserviceaccount.com

k8s-admin-vm:
	@gcloud beta compute instances create k8s-admin \
		--zone=us-central1-b --machine-type=e2-medium --subnet=tmp-admin-subnet \
		--no-address --maintenance-policy=MIGRATE --no-service-account --no-scopes \
		--tags=ssh-iap --private-network-ip=10.0.1.2 --metadata=block-project-ssh-keys=true \
		--image=debian-10-buster-v20220303 --image-project=debian-cloud --boot-disk-size=10GB \
		--boot-disk-type=pd-ssd --boot-disk-device-name=dbs-k8s-jumpbox --shielded-secure-boot \
		--shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any -q \
		--metadata-from-file=startup-script=./.hack/gke/k8s-admin-vm-startup.sh