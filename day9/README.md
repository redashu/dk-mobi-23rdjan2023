## getting started

### Revision 

<img src="deployapp.png">

### One more clouser look 

<img src="final.png">

### verify last day deployment 

```
[ashu@docker-host ashu-apps]$ kubectl  config get-contexts 
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   ashu-project
[ashu@docker-host ashu-apps]$ kubectl  get  deploy 
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
ashu-mobi-ui   3/3     3            3           21h
[ashu@docker-host ashu-apps]$ kubectl  get  hpa
NAME           REFERENCE                 TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
ashu-mobi-ui   Deployment/ashu-mobi-ui   0%/85%    3         20        3          21h
[ashu@docker-host ashu-apps]$ kubectl  get pods -o wide
NAME                            READY   STATUS    RESTARTS      AGE   IP                NODE    NOMINATED NODE   READINESS GATES
ashu-mobi-ui-6c8874f549-4q9jc   1/1     Running   1 (19h ago)   21h   192.168.135.21    node3   <none>           <none>
ashu-mobi-ui-6c8874f549-dzz2c   1/1     Running   1 (19h ago)   21h   192.168.104.24    node2   <none>           <none>
ashu-mobi-ui-6c8874f549-ggfsr   1/1     Running   1 (19h ago)   21h   192.168.166.135   node1   <none>           <none>
[ashu@docker-host ashu-apps]$ kubectl  get  svc
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
ashu-svc1   ClusterIP   10.107.101.151   <none>        1234/TCP   20h
[ashu@docker-host ashu-apps]$ kubectl  get  ingress
NAME                    CLASS   HOSTS             ADDRESS         PORTS   AGE
ashu-app-ingress-rule   nginx   me.ashutoshh.in   172.31.17.130   80      20h
[ashu@docker-host ashu-apps]$ 
```

### change something in UI app -- build -push it docker hub 

```
1009  cd ashu-ui-app/
 1010  ls
 1011  docker images  |  grep ashu
 1012  docker build -t ashumobi:uiv2 -f nginx.dockerfile  . 
 1013  history 
[ashu@docker-host ashu-ui-app]$ 
[ashu@docker-host ashu-ui-app]$ docker images  |  grep ashu
ashumobi                            uiv2      99e99a306420   13 seconds ago   142MB
dockerashu/ashumobi                 uiv1      c58f0bc54191   24 hours ago     142MB
ashumobi                            uiv1      c58f0bc54191   24 hours ago     142MB
dockerashu/ashu-mobiwebapp          v1        7aeab02a7ecf   2 days ago       461MB
dockerashu/ashu-mobiwebapp          <none>    af4b91c944ef   2 days ago       461MB
dockerashu/ashu-ui                  mobiv1    f45551527ab7   2 days ago       144MB
dockerashu/ashu-ui                  <none>    eff1395a1609   2 days ago       144MB
ashu-compose-examples-myapp         latest    133d735eb1da   5 days ago       475MB
[ashu@docker-host ashu-ui-app]$ docker tag  ashumobi:uiv2  docker.io/dockerashu/ashumobi:uiv2 
[ashu@docker-host ashu-ui-app]$ docker login 
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/ashu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[ashu@docker-host ashu-ui-app]$ docker push docker.io/dockerashu/ashumobi:uiv2
The push refers to repository [docker.io/dockerashu/ashumobi]
493b10705743: Pushed 
80115eeb30bc: Layer already exists 
049fd3bdb25d: Layer already exists 
ff1154af28db: Layer already exists 
8477a329ab95: Layer already exists 
7e7121bf193a: Layer already exists 
67a4178b7d47: Layer already exists 
uiv2: digest: sha256:162d6c59f2702d9bcc6ba31a977968389b51bbe8c698b6e109b062b40076e973 size: 1779
[ashu@docker-host ashu-ui-app]$ 
```

### app upgradation strategy for deployment controller

<img src="upgrade.png">

### manual update of image in deployment 

```
[ashu@docker-host ashu-apps]$ kubectl  set  image deployment  ashu-mobi-ui   ashumobi=docker.io/dockerashu/ashumobi:uiv2
deployment.apps/ashu-mobi-ui image updated
```

### checking image

```
ashu@docker-host ashu-apps]$ kubectl  describe  deployment  ashu-mobi-ui 
Name:                   ashu-mobi-ui
Namespace:              ashu-project
CreationTimestamp:      Wed, 01 Feb 2023 12:15:57 +0000
Labels:                 app=ashu-mobi-ui
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=ashu-mobi-ui
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=ashu-mobi-ui
  Containers:
   ashumobi:
    Image:        docker.io/dockerashu/ashumobi:uiv2
    Port:         80/TCP
    Host Port:    0/TCP
```

### rollout to rollback app 

```
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ kubectl rollout undo deployment ashu-mobi-ui 
deployment.apps/ashu-mobi-ui rolled back
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ kubectl  describe deploy ashu-mobi-ui 
Name:                   ashu-mobi-ui
Namespace:              ashu-project
CreationTimestamp:      Wed, 01 Feb 2023 12:15:57 +0000
Labels:                 app=ashu-mobi-ui
Annotations:            deployment.kubernetes.io/revision: 3
Selector:               app=ashu-mobi-ui
Replicas:               3 desired | 3 updated | 4 total | 3 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=ashu-mobi-ui
  Containers:
   ashumobi:
    Image:        docker.io/dockerashu/ashumobi:uiv1
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
```

### lets clean all the resources in Namespace 

```
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ 
[ashu@docker-host ashu-apps]$ kubectl delete all --all
pod "ashu-mobi-ui-6c8874f549-2nc7x" deleted
pod "ashu-mobi-ui-6c8874f549-m4xkg" deleted
pod "ashu-mobi-ui-6c8874f549-rmqkj" deleted
service "ashu-svc1" deleted
deployment.apps "ashu-mobi-ui" deleted
horizontalpodautoscaler.autoscaling "ashu-mobi-ui" deleted
[ashu@docker-host ashu-apps]$ kubectl  get  ing
NAME                    CLASS   HOSTS             ADDRESS         PORTS   AGE
ashu-app-ingress-rule   nginx   me.ashutoshh.in   172.31.17.130   80      21h
[ashu@docker-host ashu-apps]$ kubectl delete ing ashu-app-ingress-rule 
ingress.networking.k8s.io "ashu-app-ingress-rule" deleted
[ashu@docker-host ashu-apps]$ 
```

### Introduction to ConfigMap & Secret 

<img src="sec.png">

### use configMap 

### dockerfile 

```
FROM oraclelinux:8.4
ENV code=blue
RUN mkdir /test
COPY hello.sh /test/
WORKDIR /test
RUN chmod +x hello.sh
ENTRYPOINT ["./hello.sh"]
```

### hello.sh 

```
#!/bin/bash

if [ "$code" == "blue"  ]
then
    while [ true ]
    do  
        echo "Hello i am code Blue !!!"
        sleep 10 
    done
elif [ "$code" == "black"  ]
then
    while [ true ]
    do
        echo "Hello i am code black !!!"
        sleep 10
    done
fi 
```

### deploy test image 

```
[ashu@docker-host k8s-app-deploy]$ kubectl create deployment ashu-test --image=docker.io/dockerashu/testing:v1 --dry-run=client -o yaml >testcm.yaml 
[ashu@docker-host k8s-app-deploy]$ kubectl apply -f testcm.yaml 
deployment.apps/ashu-test created
[ashu@docker-host k8s-app-deploy]$ kubectl  get  deploy 
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
ashu-test   0/1     1            0           3s
[ashu@docker-host k8s-app-deploy]$ kubectl  get  po
NAME                         READY   STATUS    RESTARTS   AGE
ashu-test-8689b84f64-8rhcc   1/1     Running   0          6s
[ashu@docker-host k8s-app-deploy]$ 

```








