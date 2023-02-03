## getting started

### Storage COncept 

<img src="st.png">

## Deploying PostGreSQL 

### creating configMap to store info 

```
[ashu@docker-host post-gre-deploy]$ kubectl create configmap  ashu-postgre-cm --from-literal  POSTGRES_USER=admin  --dry-run=client -o yaml  >configmap.yaml 
[ashu@docker-host post-gre-deploy]$ ls
configmap.yaml
```

### updating more ENv section in CM 

```
apiVersion: v1
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: ashu-postgre-cm
data:
  POSTGRES_USER: admin
  POSTGRES_DB: ashdudb

```

#### lets deploy that 

```
[ashu@docker-host post-gre-deploy]$ ls
configmap.yaml
[ashu@docker-host post-gre-deploy]$ kubectl apply -f configmap.yaml 
configmap/ashu-postgre-cm created
[ashu@docker-host post-gre-deploy]$ kubectl  get  cm 
NAME               DATA   AGE
ashu-db-details    1      36m
ashu-env-cm        2      22h
ashu-postgre-cm    2      5s
kube-root-ca.crt   1      3d21h
[ashu@docker-host post-gre-deploy]$ 
```

### creating secret to store password or any confidential info 

```
[ashu@docker-host post-gre-deploy]$ kubectl  create secret  generic ashu-postgre-secret  --from-literal  mypass="MobiAshu@098#" --dry-run=client -o yaml >secret.yaml 
```
