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