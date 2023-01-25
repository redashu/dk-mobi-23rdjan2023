## getting started

### Revision 

<img src="rev.png">

### web app containerization 

###. about web servers 

<img src="webs.png">

### Nginx web app server info 

<img src="nginx.png">

## Lets containerize fronend website 

### need source code 

```
[ashu@docker-host ashu-apps]$ ls
javaapp  webapps
[ashu@docker-host ashu-apps]$ cd  webapps/
[ashu@docker-host webapps]$ ls
[ashu@docker-host webapps]$ git clone https://github.com/yenchiah/project-website-template.git
Cloning into 'project-website-template'...
remote: Enumerating objects: 1025, done.
remote: Total 1025 (delta 0), reused 0 (delta 0), pack-reused 1025
Receiving objects: 100% (1025/1025), 1.64 MiB | 31.66 MiB/s, done.
Resolving deltas: 100% (633/633), done.
[ashu@docker-host webapps]$ ls
project-website-template
[ashu@docker-host webapps]$
```

### dockerfile code 

```
FROM nginx 
label email=ashutoshh@linux.com 
COPY project-website-template /usr/share/nginx/html/
# copy can add file or folder to docker image 
# if we are not using CMD so base image cmd will be inherited 

```

### .dockerignore 

```
project-website-template/.git
project-website-template/.github
project-website-template/.gitignore
project-website-template/LICENSE
project-website-template/README.md
```

### lets build it 

```
[ashu@docker-host webapps]$ ls
Dockerfile  project-website-template
[ashu@docker-host webapps]$ docker build -t  ashunginx:webappv1 . 
Sending build context to Docker daemon   1.73MB
Step 1/3 : FROM nginx
latest: Pulling from library/nginx
8740c948ffd4: Pull complete 
d2c0556a17c5: Pull complete 
c8b9881f2c6a: Pull complete 
693c3ffa8f43: Pull complete 
8316c5e80e6d: Pull complete 
b2fe3577faa4: Pull complete 
Digest: sha256:b8f2383a95879e1ae064940d9a200f67a6c79e710ed82ac42263397367e7cc4e
Status: Downloaded newer image for nginx:latest
 ---> a99a39d070bf
Step 2/3 : label email=ashutoshh@linux.com
 ---> Running in 23e63e55cace
Removing intermediate container 23e63e55cace
 ---> 0c501c9782c5
Step 3/3 : COPY project-website-template /usr/share/nginx/html/
 ---> a8b5aa15a99d
Successfully built a8b5aa15a99d
Successfully tagged ashunginx:webappv1
[ashu@docker-host webapps]$ 
```

### verify 

```
[ashu@docker-host webapps]$ docker images
REPOSITORY   TAG        IMAGE ID       CREATED          SIZE
ashunginx    webappv1   a8b5aa15a99d   12 seconds ago   144MB
nginx        latest     a99a39d070bf   2 weeks ago      142MB
```
### launching a container 

```
[ashu@docker-host ashu-apps]$ docker  run -itd  --name ashuwebappc1  -p  1234:80 ashunginx:webappv1  
db95870cb71b59c515c6894e84fbb27f231f848aa783018f203d4b70891a4fbd
[ashu@docker-host ashu-apps]$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS                                   NAMES
db95870cb71b   ashunginx:webappv1     "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   0.0.0.0:1234->80/tcp, :::1234->80/tcp   ashuwebappc1
```

### COntainer restart policy 

<img src="restart.png">

### list of restart policy in docker 

<img src="res.png">

### printing restart policy of any running or  non running container 

```
[ashu@docker-host ashu-apps]$ docker  inspect  ashuwebappc1  --format='{{.Id}}'
db95870cb71b59c515c6894e84fbb27f231f848aa783018f203d4b70891a4fbd
[ashu@docker-host ashu-apps]$ docker  inspect  ashuwebappc1  --format='{{.State.Status}}'
exited
[ashu@docker-host ashu-apps]$ docker  inspect  ashuwebappc1  --format='{{.HostConfig.RestartPolicy.Name}}'
no
[ashu@docker-host ashu-apps]$ 

```

### changing restart policy of an existing container 

```
[ashu@docker-host ashu-apps]$ docker update  ashuwebappc1  --restart  always 
ashuwebappc1
[ashu@docker-host ashu-apps]$ docker  inspect  ashuwebappc1  --format='{{.HostConfig.RestartPolicy.Name}}'
always
[ashu@docker-host ashu-apps]$ 

```

### assigning restart policy during container creation time 

```
[ashu@docker-host ashu-apps]$  docker  run -itd  --name ashuwebappc1  -p  1234:80   --restart unless-stopped        ashunginx:webappv1
1a8cefefd026e73d311ea0630ef688bbe8efb605b7533d8cdc551d1e941b9fba
[ashu@docker-host ashu-apps]$ docker  inspect  ashuwebappc1  --format='{{.HostConfig.RestartPolicy.Name}}'
unless-stopped
[ashu@docker-host ashu-apps]$ 

```








