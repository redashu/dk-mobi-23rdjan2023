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

### secret creation 

```
[ashu@docker-host post-gre-deploy]$ kubectl apply -f secret.yaml 
secret/ashu-postgre-secret created
[ashu@docker-host post-gre-deploy]$ kubectl  get  secret 
NAME                  TYPE                                  DATA   AGE
ashu-db-cred          Opaque                                1      41m
ashu-postgre-secret   Opaque                                1      6s
default-token-s2d7c   kubernetes.io/service-account-token   3      3d21h
[ashu@docker-host post-gre-deploy]$ 

```

### volume info in k8s 

<img src="vol.png">

### Deployment creation 

```
[ashu@docker-host post-gre-deploy]$ kubectl  create  deployment  ashu-post-db --image=postgres  --port 5432 --dry-run=client  -o yaml >deployment.yaml 
[ashu@docker-host post-gre-deploy]$ ls
configmap.yaml  deployment.yaml  secret.yaml
[ashu@docker-host post-gre-deploy]$ 

```

### updataing deployment file for volume related data 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashu-post-db
  name: ashu-post-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-post-db
  strategy: {}
  template: # template section 
    metadata:
      creationTimestamp: null
      labels:
        app: ashu-post-db
    spec:
      volumes: # for creating volume 
      - name: ashu-vol123 # name of volume 
        hostPath: # type of volume -- hostpath means local node storage 
          path: /mnt/ashudb-space  # this directory will be created automatically 
          type: Directory 
      containers: # for creating container 
      - image: postgres
        name: postgres
        ports:
        - containerPort: 5432
        volumeMounts: # attaching / mounting volume we created above 
        - name: ashu-vol123 
          mountPath: /var/lib/postgresql/data/ 
        resources: {}
status: {}

```

### updating configMap & Secret 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ashu-post-db
  name: ashu-post-db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ashu-post-db
  strategy: {}
  template: # template section 
    metadata:
      creationTimestamp: null
      labels:
        app: ashu-post-db
    spec:
      volumes: # for creating volume 
      - name: ashu-vol123 # name of volume 
        hostPath: # type of volume -- hostpath means local node storage 
          path: /mnt/ashudb-space  # this directory will be created automatically 
          type: DirectoryOrCreate
      containers: # for creating container 
      - image: postgres
        name: postgres
        ports:
        - containerPort: 5432
        volumeMounts: # attaching / mounting volume we created above 
        - name: ashu-vol123 
          mountPath: /var/lib/postgresql/data/ 
        envFrom: # to calling configmap / secret directly 
        - configMapRef:
            name: ashu-postgre-cm
        env: # to use / create ENV in pod container 
        - name: POSTGRES_PASSWORD
          valueFrom: 
            secretKeyRef:
              name: ashu-postgre-secret
              key: mypass
        resources: {}
status: {}

```

### deploy it 

```
[ashu@docker-host post-gre-deploy]$ kubectl apply -f deployment.yaml 
Warning: resource deployments/ashu-post-db is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/ashu-post-db configured
[ashu@docker-host post-gre-deploy]$ kubectl  get  deploy 
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
ashu-post-db   1/1     1            1           78s
[ashu@docker-host post-gre-deploy]$ kubectl  get  po
NAME                            READY   STATUS    RESTARTS   AGE
ashu-post-db-794dd57599-kg2f8   1/1     Running   0          81s
[ashu@docker-host post-gre-deploy]
```
### creating service for db 

```
[ashu@docker-host ashu-apps]$ kubectl  get deploy 
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
ashu-post-db   1/1     1            1           14m
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ kubectl  expose  deployment  ashu-post-db  --type ClusterIP --port 5432 --name ashu-svc1 --dry-run=client -o yaml >svc.yaml 
[ashu@docker-host ashu-apps]$ kubectl  apply -f svc.yaml 
service/ashu-svc1 created
[ashu@docker-host ashu-apps]$ kubectl  get  svc
NAME        TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
ashu-svc1   ClusterIP   10.97.28.6   <none>        5432/TCP   4s
[ashu@docker-host ashu-apps]$ 



```


### lets clean up 

```
[ashu@docker-host ashu-apps]$ kubectl delete all,cm,secret  --all 
pod "ashu-post-db-7d65467b9f-rv4l2" deleted
service "ashu-svc1" deleted
deployment.apps "ashu-post-db" deleted
replicaset.apps "ashu-post-db-7d65467b9f" deleted
configmap "ashu-db-details" deleted
configmap "ashu-env-cm" deleted
configmap "ashu-postgre-cm" deleted
configmap "kube-root-ca.crt" deleted
secret "ashu-db-cred" deleted
secret "ashu-postgre-secret" deleted
secret "default-token-s2d7c" deleted
[ashu@docker-host ashu-apps]$ 
```


