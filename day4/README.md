## getting started

### image pushing to GCR 

```
392  tar xvzf google-cloud-cli-415.0.0-linux-x86_64.tar.gz 
  393  ls
  394  rm google-cloud-cli-415.0.0-linux-x86_64.tar.gz 
  395  ls
  396  cd  google-cloud-sdk/
  397  ls
  398  ./install.sh 
  399  history 
  400  gcloud 
  401  gcloud init 
  402  history 
  403  gcloud projects list 
  404  docker images  |  grep ashu
  405  docker  tag  a8b5aa15a99d   gcr.io/pivotal-biplane-375806/ashumobi:webappv1 
  406  docker images  |  grep ashu
  407  docker push  gcr.io/pivotal-biplane-375806/ashumobi:webappv1
  408   gcloud auth configure-docker
```

### Docker Compose 

<img src="compose.png">

### more info about Compose 

<img src="composef.png">

## compose examples 

### example 1 

```
version:  '3.8' # version of compose file 
services: # name of apps which you want to containerize
  ashu-ui:
    image: ashunginx:webappv1
    container_name: ashu-ui-c1
    restart: always 
    ports:
    - 1234:80

```

### lets run the file 

```
[ashu@docker-host ashu-apps]$ ls
ashu-compose-examples  google-cloud-sdk  javaapp  tools  webapps
[ashu@docker-host ashu-apps]$ cd  ashu-compose-examples/
[ashu@docker-host ashu-compose-examples]$ ls
docker-compose.yaml
[ashu@docker-host ashu-compose-examples]$ docker-compose  up -d 
[+] Running 2/2
 ⠿ Network ashu-compose-examples_default  Created                                                                         0.0s
 ⠿ Container ashu-ui-c1                   Started                                                                         0.6s
[ashu@docker-host ashu-compose-examples]$ docker-compose  ps
NAME                IMAGE                COMMAND                  SERVICE             CREATED             STATUS              PORTS
ashu-ui-c1          ashunginx:webappv1   "/docker-entrypoint.…"   ashu-ui             15 seconds ago      Up 15 seconds       0.0.0.0:1234->80/tcp, :::1234->80/tcp
[ashu@docker-host ashu-compose-examples]$ 

```


