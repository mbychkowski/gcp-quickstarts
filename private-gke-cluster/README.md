# Private GKE Cluster

```
make cluster
```

```
kubectl create deployment nginx --image=nginx --replicas 3 --port=8080
```

```
kubectl run utils --image=busybox --restart=Never -- sleep 3600
```

```
gcloud compute ssh --zone <location> <node-name>  --internal-ip --project <project-id>
```

```
ip link show
```

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 42:01:0a:00:00:02 brd ff:ff:ff:ff:ff:ff
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:49:a7:5f:5f brd ff:ff:ff:ff:ff:ff
4: vethbdfd7c58@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 3e:d6:13:e8:14:d9 brd ff:ff:ff:ff:ff:ff link-netns cni-8af2aeb6-6a15-4c70-85d9-2402c89475f6
5: veth835a6bec@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 2e:8d:25:d4:3e:65 brd ff:ff:ff:ff:ff:ff link-netns cni-c9d8b6f1-718a-86cd-bae2-5027d3cb8b6f
8: vethaf6a6bb3@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 72:0c:61:0d:0f:bc brd ff:ff:ff:ff:ff:ff link-netns cni-de0a5cbf-c896-4c52-3907-dfde7328261f
10: vethf838d6a2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1460 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 7a:d8:dc:50:aa:a3 brd ff:ff:ff:ff:ff:ff link-netns cni-cd501b3d-360b-a31c-93e1-b7771200fa53
```

```
ip route
```

```
ping

arp -a
```

```
(172.16.0.1) at 7a:d8:dc:50:aa:a3 [ether]  on eth0
```

```
kubectl expose deploy nginx --port 80 --target-port 8080 --type ClusterIP 
```
