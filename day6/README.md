## Revision 

### Docker revision 

<img src="rev.png">

### K8s Revision 

<img src="rev1.png">

### checking connection to k8s control plane 

```
[ashu@docker-host ashu-apps]$ kubectl  cluster-info 
Kubernetes control plane is running at https://172.31.29.6:6443
CoreDNS is running at https://172.31.29.6:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ kubectl  get  nodes
NAME            STATUS   ROLES                  AGE    VERSION
control-plane   Ready    control-plane,master   3d2h   v1.23.16
node1           Ready    <none>                 3d2h   v1.23.16
node2           Ready    <none>                 3d2h   v1.23.16
node3           Ready    <none>                 3d2h   v1.23.16
[ashu@docker-host ashu-apps]$ 
```

### etcd the brain of k8s -- running in CP / master node 

<img src="etcd.png">

## k8s will run app container in a env called POD 

### POd info 

<img src="pod.png">

### pushing image to deploy in k8s 

```
[ashu@docker-host webapps]$ ls
Dockerfile  project-website-template
[ashu@docker-host webapps]$ docker build -t  docker.io/dockerashu/ashu-ui:mobiv1 . 
Sending build context to Docker daemon   1.73MB
Step 1/3 : FROM nginx
 ---> a99a39d070bf
Step 2/3 : label email=ashutoshh@linux.com
 ---> Running in b92157f0fc4f
Removing intermediate container b92157f0fc4f
 ---> 4008272a8a67
Step 3/3 : COPY project-website-template /usr/share/nginx/html/
 ---> eff1395a1609
Successfully built eff1395a1609
Successfully tagged dockerashu/ashu-ui:mobiv1
[ashu@docker-host webapps]$ docker login -u dockerashu
Password: 
WARNING! Your password will be stored unencrypted in /home/ashu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[ashu@docker-host webapps]$ docker push docker.io/dockerashu/ashu-ui:mobiv1
The push refers to repository [docker.io/dockerashu/ashu-ui]
784d477c1a69: Pushed 
80115eeb30bc: Mounted from library/nginx 
049fd3bdb25d: Mounted from library/nginx 
ff1154af28db: Mounted from library/nginx 
8477a329ab95: Mounted from library/nginx 
7e7121bf193a: Mounted from library/nginx 
67a4178b7d47: Mounted from library/nginx 
mobiv1: digest: sha256:e6e1111eddfee0b1ca40d72d04e07f7f0c58153ee448575272572b0be81c1e68 size: 1781
[ashu@docker-host webapps]$ 
```

### Most sample Pod YAML file 

```
apiVersion: v1 # apiserver version to target 
kind: Pod  # Resource on apiversion 
metadata: # info about Resource like POd 
  name: ashu-test-pod  
spec: # need of pod like services in compose 
  containers: # number of container for my app 
  - image: docker.io/dockerashu/ashu-ui:mobiv1
    name: ashuc1
    ports:
    - containerPort: 80 # container app port number 
```

### lets deploy it 

```
[ashu@docker-host ashu-apps]$ ls
admin.conf  ashu-compose-examples  ashu-docker-final  javaapp  k8s-app-deploy  tools  webapps
[ashu@docker-host ashu-apps]$ cd  k8s-app-deploy/
[ashu@docker-host k8s-app-deploy]$ ls
ashupod1.yaml
[ashu@docker-host k8s-app-deploy]$ kubectl apply -f  ashupod1.yaml 
pod/ashu-test-pod created
[ashu@docker-host k8s-app-deploy]$ kubectl  get  pods
NAME               READY   STATUS    RESTARTS   AGE
ashu-test-pod      1/1     Running   0          14s
daniela-test-pod   1/1     Running   0          7s
scunha-test-pod    1/1     Running   0          12s
[ashu@docker-host k8s-app-deploy]$ 

```

### where control plane planned our pods 

```
[ashu@docker-host webapps]$ kubectl  get  pod  ashu-test-pod -o wide 
NAME            READY   STATUS    RESTARTS   AGE   IP              NODE    NOMINATED NODE   READINESS GATES
ashu-test-pod   1/1     Running   0          13m   192.168.104.3   node2   <none>           <none>
[ashu@docker-host webapps]$ 

```

### checking more 

```
[ashu@docker-host webapps]$ kubectl  get  pod  -o wide 
NAME                   READY   STATUS    RESTARTS   AGE     IP                NODE    NOMINATED NODE   READINESS GATES
acsilva-test-pod       1/1     Running   0          8m54s   192.168.166.137   node1   <none>           <none>
ashu-test-pod          1/1     Running   0          15m     192.168.104.3     node2   <none>           <none>
cfantao-test-pod       1/1     Running   0          9m36s   192.168.166.136   node1   <none>           <none>
daniela-test-pod       1/1     Running   0          15m     192.168.135.5     node3   <none>           <none>
dvvlad-test-pod        1/1     Running   0          9m34s   192.168.104.5     node2   <none>           <none>
jji-test-pod           1/1     Running   0          7m2s    192.168.135.7     node3   <none>           <none>
jjunior-pod1           1/1     Running   0          8m54s   192.168.135.6     node3   <none>           <none>
jpconceicao-test-pod   1/1     Running   0          14m     192.168.104.4     node2   <none>           <none>
lzmartin-test-pod      1/1     Running   0          6m54s   192.168.104.6     node2   <none>           <none>
nmgrilo-test-pod       1/1     Running   0          14m     192.168.166.135   node1   <none>           <none>
scunha-test-pod        1/1     Running   0          15m     192.168.135.4     node3   <none>           <none>
[ashu@docker-host webapps]$ kubectl  get  pod  -o wide   |  wc -l
12
[ashu@docker-host webapps]$ 

```

### Pod scheduling done by control plane component called -- Scheduler 

<img src="sch.png">

## More pod commands 

### checking logs of pod container 

```
ashu@docker-host webapps]$ kubectl  logs ashu-test-pod
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2023/01/30 10:13:14 [notice] 1#1: using the "epoll" event method
2023/01/30 10:13:14 [notice] 1#1: nginx/1.23.3
2023/01/30 10:13:14 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6) 
2023/01/30 10:13:14 [notice] 1#1: OS: Linux 5.10.162-141.675.amzn2.x86_64
2023/01/30 10:13:14 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 32768:65
```

### accessing container shell inside pod 

```
[ashu@docker-host webapps]$ kubectl  exec  -it ashu-test-pod  -- bash 
root@ashu-test-pod:/# ls
bin  boot  dev  docker-entrypoint.d  docker-entrypoint.sh  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@ashu-test-pod:/# exit
exit
```

### describe pod 

```
[ashu@docker-host webapps]$ kubectl  describe pod ashu-test-pod
Name:         ashu-test-pod
Namespace:    default
Priority:     0
Node:         node2/172.31.26.13
Start Time:   Mon, 30 Jan 2023 10:13:08 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 99e8a5a5b9e1afd04ed5d18d9950a3f5bdf349003ace866f912c5221eebd5df0
              cni.projectcalico.org/podIP: 192.168.104.3/32
              cni.projectcalico.org/podIPs: 192.168.104.3/32
Status:       Running
IP:           192.168.104.3
IPs:
  IP:  192.168.104.3
Containers:
  ashuc1:
    Container ID:   docker://25ebe1e324b3b7103d2d243e49c4b71454e51fff7ce29aa0898580829ace5b28
    Image:          docker.io/dockerashu/ashu-ui:mobiv1
    Image ID:       docker-pullable://dockerashu/ashu-ui@sha256:e6e1111eddfee0b1ca40d72d04e07f7f0c58153ee448575272572b0be81c1e68
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 30 Jan 2023 10:13:14 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-gc67f (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-gc67f:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  26m   default-scheduler  Successfully assigned default/ashu-test-pod to node2
  Normal  Pulling    26m   kubelet            Pulling image "docker.io/dockerashu/ashu-ui:mobiv1"
  Normal  Pulled     26m   kubelet            Successfully pulled image "docker.io/dockerashu/ashu-ui:mobiv1" in 3.420635353s (3.420643345s including waiting)
  Normal  Created    26m   kubelet            Created container ashuc1
  Normal  Started    26m   kubelet            Started container ashuc1
```

### events 

```
[ashu@docker-host webapps]$ kubectl  get events 
LAST SEEN   TYPE      REASON      OBJECT                     MESSAGE
20m         Normal    Scheduled   pod/acsilva-test-pod       Successfully assigned default/acsilva-test-pod to node1
20m         Normal    Pulling     pod/acsilva-test-pod       Pulling image "docker.io/acsilva80/acsilva-ui:mobiv1"
20m         Normal    Pulled      pod/acsilva-test-pod       Successfully pulled image "docker.io/acsilva80/acsilva-ui:mobiv1" in 435.395539ms (435.403282ms including waiting)
20m         Normal    Created     pod/acsilva-test-pod
```

### delete pod 

```
[ashu@docker-host webapps]$ kubectl delete pod  ashu-test-pod 
pod "ashu-test-pod" deleted
```

## Generate POd YAML and instance also 

```
[ashu@docker-host k8s-app-deploy]$ kubectl  run  ashu-webpod  --image=docker.io/dockerashu/ashu-ui:mobiv1 --port 80 
pod/ashu-webpod created
[ashu@docker-host k8s-app-deploy]$ kubectl  get  pods
NAME          READY   STATUS    RESTARTS   AGE
ashu-webpod   1/1     Running   0          4s
[ashu@docker-host k8s-app-deploy]$ 

```

### YAML / JSON 

```
[ashu@docker-host k8s-app-deploy]$ kubectl  run  ashu-webpod  --image=docker.io/dockerashu/ashu-ui:mobiv1 --port 80  --dry-run=client -o yaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ashu-webpod
  name: ashu-webpod
spec:
  containers:
  - image: docker.io/dockerashu/ashu-ui:mobiv1
    name: ashu-webpod
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
[ashu@docker-host k8s-app-deploy]$ kubectl  get pods
No resources found in default namespace.
[ashu@docker-host k8s-app-deploy]$ kubectl  run  ashu-webpod  --image=docker.io/dockerashu/ashu-ui:mobiv1 --port 80  --dry-run=client -o yaml  >autopod.yaml 
[ashu@docker-host k8s-app-deploy]$ 
```

### JSOn 

```
[ashu@docker-host k8s-app-deploy]$ kubectl  run  ashu-webpod  --image=docker.io/dockerashu/ashu-ui:mobiv1 --port 80  --dry-run=client -o json 
{
    "kind": "Pod",
    "apiVersion": "v1",
    "metadata": {
        "name": "ashu-webpod",
        "creationTimestamp": null,
        "labels": {
            "run": "ashu-webpod"
        }
    },
    "spec": {
        "containers": [
            {
                "name": "ashu-webpod",
                "image": "docker.io/dockerashu/ashu-ui:mobiv1",
                "ports": [
                    {
                        "containerPort": 80
                    }
                ],
                "resources": {}
            }
        ],
        "restartPolicy": "Always",
        "dnsPolicy": "ClusterFirst"
    },
    "status": {}
}
[ashu@docker-host k8s-app-deploy]$ kubectl  run  ashu-webpod  --image=docker.io/dockerashu/ashu-ui:mobiv1 --port 80  --dry-run=client -o json >autopod.json 
[ashu@docker-host k8s-app-deploy]$ 

```

### lets test it 

```
[ashu@docker-host k8s-app-deploy]$ ls
ashupod1.yaml  autopod.json  autopod.yaml
[ashu@docker-host k8s-app-deploy]$ 
[ashu@docker-host k8s-app-deploy]$ kubectl apply -f autopod.json 
pod/ashu-webpod created
[ashu@docker-host k8s-app-deploy]$ kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
ashu-webpod   1/1     Running   0          4s
[ashu@docker-host k8s-app-deploy]$ 
[ashu@docker-host k8s-app-deploy]$ kubectl delete -f autopod.json 
pod "ashu-webpod" deleted
[ashu@docker-host k8s-app-deploy]$ 


```
## Solution of task 1 

### YAML 

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: ashupod1
  name: ashupod1
spec:
  containers:
  - image: busybox
    name: ashupod1
    command: ["ping","8.8.8.8"] # replacing default CMD in docker image 
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```
### deploy it 

```
kubectl apply -f task1.yaml 
```

### transfer it 

```
[ashu@docker-host k8s-app-deploy]$ kubectl logs ashupod1
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=52 time=0.762 ms
64 bytes from 8.8.8.8: seq=1 ttl=52 time=0.744 ms
64 bytes from 8.8.8.8: seq=2 ttl=52 time=0.720 ms
64 bytes from 8.8.8.8: seq=3 ttl=52 time=0.739 ms
64 bytes from 8.8.8.8: seq=4 ttl=52 time=0.731 ms
64 bytes from 8.8.8.8: seq=5 ttl=52 time=0.710 ms
64 bytes from 8.8.8.8: seq=6 ttl=52 time=0.790 ms
64 bytes from 8.8.8.8: seq=7 ttl=52 time=0.729 ms
64 bytes from 8.8.8.8: seq=8 ttl=52 time=0.656 ms
64 bytes from 8.8.8.8: seq=9 ttl=52 time=0.747 ms
64 bytes from 8.8.8.8: seq=10 ttl=52 time=0.764 ms
[ashu@docker-host k8s-app-deploy]$ kubectl logs ashupod1  >logs.txt 
[ashu@docker-host k8s-app-deploy]$ ls
ashupod1.yaml  autopod.json  autopod.yaml  logs.txt  task1.yaml
[ashu@docker-host k8s-app-deploy]$ kubectl  exec  ashupod1 -- sh 
[ashu@docker-host k8s-app-deploy]$ kubectl  exec -it  ashupod1 -- sh 
/ # 
/ # ls  /
bin    dev    etc    home   lib    lib64  proc   root   sys    tmp    usr    var
/ # mkdir /opt
/ # ls 
bin    dev    etc    home   lib    lib64  opt    proc   root   sys    tmp    usr    var
/ # exit
[ashu@docker-host k8s-app-deploy]$ ls
ashupod1.yaml  autopod.json  autopod.yaml  logs.txt  task1.yaml
[ashu@docker-host k8s-app-deploy]$ kubectl cp logs.txt  ashupod1:/opt/
[ashu@docker-host k8s-app-deploy]$ 
[ashu@docker-host k8s-app-deploy]$ kubectl  exec -it  ashupod1 -- ls /opt
logs.txt
[ashu@docker-host k8s-app-deploy]$ 
```

### update more 

```
[ashu@docker-host k8s-app-deploy]$ kubectl  exec -it  ashupod1 -- sh 
/ # 
/ # cd /opt/
/opt # ls
logs.txt
/opt # echo node3  >>logs.txt 
/opt # cat logs.txt 
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=52 time=0.762 ms
64 bytes from 8.8.8.8: seq=1 ttl=52 time=0.744 ms
64 bytes from 8.8.8.8: seq=2 ttl=52 time=0.720 ms
64 bytes from 8.8.8.8: se
```

### Namespace in k8s 

<img src="nd.png">

### checking namespaces list 

```
[ashu@docker-host webapps]$ kubectl get  namespaces
NAME                   STATUS   AGE
default                Active   3d4h
kube-node-lease        Active   3d4h
kube-public            Active   3d4h
kube-system            Active   3d4h
kubernetes-dashboard   Active   3d4h
[ashu@docker-host webapps]$ 
```

### creating and setting ns for yourself 

```
[ashu@docker-host webapps]$ kubectl create  namespace  ashu-project 
namespace/ashu-project created
[ashu@docker-host webapps]$ kubectl get ns
NAME                   STATUS   AGE
ashu-project           Active   2s
default                Active   3d4h
jpconceicao-project    Active   0s
kube-node-lease        Active   3d4h
kube-public            Active   3d4h
kube-system            Active   3d4h
kubernetes-dashboard   Active   3d4h
[ashu@docker-host webapps]$ kubectl  config set-context --current --namespace=ashu-project
Context "kubernetes-admin@kubernetes" modified.
[ashu@docker-host webapps]$ kubectl  get  pods
No resources found in ashu-project namespace.
[ashu@docker-host webapps]$ 

```

### checking default namespace 

```
[ashu@docker-host webapps]$ kubectl  config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
[ashu@docker-host webapps]$ 

```

### deploy pod in target namespaces 

```
apiVersion: v1 # apiserver version to target 
kind: Pod  # Resource on apiversion 
metadata: # info about Resource like POd 
  name: ashu-test-pod  
  namespace: default # target namespace --if you have permission for that 
spec: # need of pod like services in compose 
  containers: # number of container for my app 
  - image: docker.io/dockerashu/ashu-ui:mobiv1
    name: ashuc1
    ports:
    - containerPort: 80 # container app port number 
```

### 

```
[ashu@docker-host k8s-app-deploy]$ kubectl apply -f  ashupod1.yaml 
pod/ashu-test-pod created
[ashu@docker-host k8s-app-deploy]$ kubectl  get  pods
NAME            READY   STATUS    RESTARTS   AGE
ashu-test-pod   1/1     Running   0          111s
[ashu@docker-host k8s-app-deploy]$ kubectl  get  pods -n default 
NAME               READY   STATUS    RESTARTS   AGE
ashu-test-pod      1/1     Running   0          12s
daniela-test-pod   1/1     Running   0          5s
scunha-test-pod    1/1     Running   0          7s
[ashu@docker-host k8s-app-deploy]$ 


```

### deleting pods 

```
ashu@docker-host k8s-app-deploy]$ kubectl delete  -f  ashupod1.yaml 
pod "ashu-test-pod" deleted
[ashu@docker-host k8s-app-deploy]$ kubectl  get  po 
NAME            READY   STATUS    RESTARTS   AGE
ashu-test-pod   1/1     Running   0          3m8s
[ashu@docker-host k8s-app-deploy]$ kubectl delete pod ashu-test-pod
pod "ashu-test-pod" deleted
[ashu@docker-host k8s-app-deploy]$ 

```






