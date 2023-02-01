## getting started

### taking same web ui code 

### index.html & dog.jpg 

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ashu-ui</title>
</head>
<body>
    <h1> This is TOp message of your web ui </h1>
    <h2> Second top message of UI </h2>
    <img src="dog.jpg" alt="error image loading">
</body>
</html>
```

## Dockerfile adding 

### dockerfile 
```
FROM nginx
LABEL name="ashutoshh"
COPY . /usr/share/nginx/html/

```

### .dockerignore 

```
nginx.dockerfile
.dockerignore
```

### build the image 

```
[ashu@docker-host ashu-ui-app]$ ls
dog.jpg  index.html  nginx.dockerfile
[ashu@docker-host ashu-ui-app]$ docker build -t  ashumobi:uiv1  -f nginx.dockerfile  . 
Sending build context to Docker daemon  38.91kB
Step 1/3 : FROM nginx
 ---> a99a39d070bf
Step 2/3 : LABEL name="ashutoshh"
 ---> Running in 83815ca3b272
Removing intermediate container 83815ca3b272
 ---> 3396abc6204f
Step 3/3 : COPY . /usr/share/nginx/html/
 ---> c58f0bc54191
Successfully built c58f0bc54191
Successfully tagged ashumobi:uiv1
[ashu@docker-host ashu-ui-app]$ docker images  |  grep ashu
ashumobi                            uiv1      c58f0bc54191   7 seconds ago   142MB
```

### pushing image on Docker Hub which is public registry 

```
[ashu@docker-host ashu-ui-app]$ docker images  |  grep ashu
ashumobi                            uiv1      c58f0bc54191   2 minutes ago        142MB
dockerashu/ashu-mobiwebapp          <none>    af4b91c944ef   24 hours ago         461MB
dockerashu/ashu-mobiwebapp          v1        7aeab02a7ecf   24 hours ago         461MB
dockerashu/ashu-ui                  mobiv1    f45551527ab7   2 days ago           144MB
dockerashu/ashu-ui                  <none>    eff1395a1609   2 days ago           144MB
ashu-compose-examples-myapp         latest    133d735eb1da   4 days ago           475MB
[ashu@docker-host ashu-ui-app]$ 
[ashu@docker-host ashu-ui-app]$ docker  tag  ashumobi:uiv1  docker.io/dockerashu/ashumobi:uiv1  
[ashu@docker-host ashu-ui-app]$ docker  login -u dockerashu
Password: 
WARNING! Your password will be stored unencrypted in /home/ashu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[ashu@docker-host ashu-ui-app]$ docker push  docker.io/dockerashu/ashumobi:uiv1 
The push refers to repository [docker.io/dockerashu/ashumobi]
b80a0366baec: Pushed 
80115eeb30bc: Mounted from dockerashu/ashu-ui 
049fd3bdb25d: Mounted from dockerashu/ashu-ui 
ff1154af28db: Mounted from dockerashu/ashu-ui 
8477a329ab95: Mounted from dockerashu/ashu-ui 
7e7121bf193a: Mounted from dockerashu/ashu-ui 
67a4178b7d47: Mounted from dockerashu/ashu-ui 
uiv1: digest: sha256:73ac06306b1e4a0b774e7dea8cb3d874c0278a87bb87a016117812e9e1f70244 size: 1779
```
