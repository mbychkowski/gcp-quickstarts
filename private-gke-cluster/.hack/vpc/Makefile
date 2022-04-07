# Source important environmental variables that need to be persisted and are easy to forget about
-include .env.make

network:
	# Create custom network for the cluster
	@gcloud compute networks create tmp-net --description="VPC Network for the Test GKE Cluster hosting Config Connector & Policy Controller" \
		--subnet-mode=custom
	# Create subnet for the cluster
	@gcloud compute networks subnets create tmp-subnet \
		--network=tmp-net \
		--range=10.0.0.0/28 \
		--secondary-range svc=192.168.64.0/25 \
		--secondary-range pod=172.16.0.0/20 \
		--description="Subnet for the automation cluster" \
		--enable-flow-logs \
		--enable-private-ip-google-access \
		--purpose=PRIVATE \
		--region=us-central1
	# Create subnet for admin VM
	@gcloud compute networks subnets create tmp-admin-subnet \
		--network=tmp-net \
		--range=10.0.1.0/28 \
		--description="Subnet to securely access the test cluster control plane" \
		--enable-flow-logs \
		--enable-private-ip-google-access \
		--purpose=PRIVATE \
		--region=us-central1
	# Create firewall rule
	@gcloud compute firewall-rules create allow-ssh-gcp --allow tcp:22,tcp:3389,icmp \
		--source-ranges="35.235.240.0/20" --description="SSH via IAP" \
		--target-tags=ssh-iap \
		--network=tmp-net
	# Create a Cloud Router for the admin VM subnet:
	@gcloud compute routers create tmp-router \
		--network=tmp-net \
		--region=us-central1
	# Create NAT 
	@gcloud compute routers nats create tmp-nat \
	    --router=tmp-router \
	    --auto-allocate-nat-external-ips \
	    --router-region=us-central1 \
	    --nat-custom-subnet-ip-ranges=tmp-admin-subnet,tmp-subnet -q
