# Internal load balancing across private VPC with Private Service Connect (PSC)

## 1) Create vpc networks and firewall rules
Create two private VPC's. The first VPC will exist in `us-central1` with two subnets. 

Run the command to create first private VPC.

```
gcloud compute networks create $PRIVATE_VPC1 \
    --project=$PROJECT_ID \
    --subnet-mode=custom \
    --mtu=1460 \
    --bgp-routing-mode=regional
```

Create the two subnets for this VPC

```
gcloud compute networks subnets create $PRIVATE_VPC1_SUBNET1 \
    --project=$PROJECT_ID \
    --range=10.0.0.0/28 \
    --network=$PRIVATE_VPC1 \
    --region=us-central1

gcloud compute networks subnets create $PRIVATE_VPC1_SUBNET2 \
    --project=$PROJECT_ID \
    --range=10.0.1.0/28 \
    --network=$PRIVATE_VPC1 \
    --region=us-central1    
```

The second VPC will als0 be a private VPC, but with a sinlge subnet that exists in `europe-west1`.

```
gcloud compute networks create $PRIVATE_VPC2 \
    --project=$PROJECT_ID \
    --subnet-mode=custom \
    --mtu=1460 \
    --bgp-routing-mode=regional
```

Create the associated subnet for this second VPC.

```
gcloud compute networks subnets create $PRIVATE_VPC2_SUBNET1 \
    --project=$PROJECT_ID \
    --range=10.0.5.0/28 \
    --network=$PRIVATE_VPC1 \
    --region=europe-west1
```

With the two VPCs created, we will create dedicated firewall rules for both.

Allow egress traffic

```
gcloud compute --project=$PROJECT_ID firewall-rules create $PRIVATE_VPC1-allow-egress \
    --direction=EGRESS \
    --priority=1000 \
    --network=$PRIVATE_VPC1 \
    --action=ALLOW \
    --rules=tcp,udp,icmp \
    --destination-ranges=0.0.0.0/0
```

Allow http ingress traffic over port 80 and 443

```
gcloud compute --project=$PROJECT_ID firewall-rules create $PRIVATE_VPC1-allow-http-ingress \
    --direction=INGRESS \
    --priority=1000 \
    --network=$PRIVATE_VPC1 \
    --action=ALLOW \
    --rules=tcp:80,tcp:443 \
    --source-ranges=0.0.0.0/0
```

Allow ssh ingress traffic over port 22

```
gcloud compute --project=$PROJECT_ID firewall-rules create $PRIVATE_VPC1-allow-ssh-ingress \
    --direction=INGRESS \
    --priority=1000 \
    --network=$PRIVATE_VPC1 \
    --action=ALLOW \
    --rules=tcp:22 \
    --source-ranges=0.0.0.0/0
```

Allow icmp (make `ping`'s).

```
gcloud compute --project=$PROJECT_ID firewall-rules create $PRIVATE_VPC1-allow-icmp-ingress \
    --direction=INGRESS \
    --priority=1000 \
    --network=$PRIVATE_VPC1 \
    --action=ALLOW \
    --rules=icmp \
    --source-ranges=0.0.0.0/0
```

Repeat for second private VPC.

## 2) Create instance templates and deploy groups

https://www.qwiklabs.com/focuses/1247?catalog_rank=%7B%22rank%22%3A2%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=15742699

## 3) Configure internal load balancers in Service Directory

https://cloud.google.com/service-directory/docs/configuring-ilb-in-sd

## 4) 

https://cloud.google.com/service-directory/docs/configuring-service-directory-zone
