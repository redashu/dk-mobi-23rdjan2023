## getting started

### Understanding journey 

<img src="j.png">


### app conflict in bare-metal servers

<img src="appc.png">

### problem with vms wrt to app deployment / testing 

<img src="prob.png">

### Introduction to container runtime engine (CRE)

<img src="cre.png">


### Docker support with OS kernels 

<img src="k.png">

### Introduction to Docker 

<img src="docker.png">

## Installing docker ce  on amazon cloud linux machine 

### checking linux kernel 

```
fire@ashutoshhs-MacBook-Air ~ % ssh  ashu@54.198.64.250
ashu@54.198.64.250's password: 

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
7 package(s) needed for security, out of 8 available
Run "sudo yum update" to apply all updates.
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ uname -r
5.10.157-139.675.amzn2.x86_64
[ashu@docker-host ~]$ docker 
-bash: docker: command not found
[ashu@docker-host ~]$ 


```

### Installing docker in linux box using root user only 

```
[root@docker-host ~]# whoami
root
[root@docker-host ~]# yum  install docker  
Failed to set locale, defaulting to C
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                                         | 3.7 kB  00:00:00     
Resolving Dependencies
--> Running transaction check
---> Package docker.x86_64 0:20.10.17-1.amzn2.0.1 will be installed
--> Processing Dependency: runc >= 1.0.0 for package: docker-20.10.17-1.amzn2.0.1.x86_64
--> Processing Dependency: libcgroup >= 0.40.rc1-5.15 for package: docker-20.10.17-1.amzn2.0.1.x86_64
--> Processing Dependency: containerd >= 1.3.2 for package: docker-20.10.17-1.amzn2.0.1.x86_64
--> Processing Dependency: pigz for package: docker-20.10.17-1.amzn2.0.1.x86_64
--> Running transaction check
---> Package containerd.x86_64 0:1.6.8-1.amzn2 will be installed
---> Package libcgroup.x86_64 0:0.41-21.amzn2 will be installed
---> Package pigz.x86_64 0:2.3.4-1.amzn2.0.1 will be installed
---> Package runc.x86_64 0:1.1.4-1.amzn2 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==========================================================================================================================================
 Package                      Arch                     Version                                  Repository                           Size
==========================================================================================================================================
Installing:
 docker                       x86_64                   20.10.17-1.amzn2.0.1                     amzn2extra-docker                    39 M
Installing for dependencies:
 containerd                   x86_64                   1.6.8-1.amzn2                            amzn2extra-docker                    27 M
 libcgroup                    x86_64                   0.41-21.amzn2                            amzn2-core                           66 k
 pigz                         x86_64                   2.3.4-1.amzn2.0.1                        amzn2-core                           81 k
 runc                         x86_64                   1.1.4-1.amzn2                            amzn2extra-docker                   2.9 M

Transaction Summary
==========================================================================================================================================
Install  1 Package (+4 Dependent packages)

Total download size: 69 M
Installed size: 260 M
Is this ok [y/d/N]: y
Downloading packages:

```

### for docker ce installation you can use below link

[docker-ce-installation](https://docs.docker.com/engine/install/)

### verify docker installation from non root user also 

```
[ashu@docker-host ~]$ docker  -v
Docker version 20.10.17, build 100c701
[ashu@docker-host ~]$ 


```

### TIp -- installing docker on mac / windows 10 /11 --using docker desktop 

<img src="dd.png">


### docker ce -- configuration and components 

<img src="com.png">

### verify local docker client and server

```
[ashu@docker-host ~]$ docker  version 
Client:
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.18.6
 Git commit:        100c701
 Built:             Wed Sep 28 23:10:17 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ docker  images
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ docker  ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
[ashu@docker-host ~]$ 


```

### on docker host / server lets start docker service 

```
[root@docker-host ~]# systemctl start  docker 
[root@docker-host ~]# systemctl status  docker 
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2023-01-23 11:19:58 UTC; 7s ago
     Docs: https://docs.docker.com
  Process: 5268 ExecStartPre=/usr/libexec/docker/docker-setup-runtimes.sh (code=exited, status=0/SUCCESS)
  Process: 5266 ExecStartPre=/bin/mkdir -p /run/docker (code=exited, status=0/SUCCESS)
 Main PID: 5270 (dockerd)
    Tasks: 9
   Memory: 22.0M
   CGroup: /system.slice/docker.service
           └─5270 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --default-ulimit nofile=32768:65536


### making service persistent after reboot 

[root@docker-host ~]# systemctl enable docker 
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[root@docker-host ~]# 

```

### lets connect from docker client users 

```
[ashu@docker-host ~]$ docker version 
Client:
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.18.6
 Git commit:        100c701
 Built:             Wed Sep 28 23:10:17 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
[ashu@docker-host ~]$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json": dial unix /var/run/docker.sock: connect: permission denied
[ashu@docker-host ~]$ 
```

### Note: by default a local non root user can not connect to docker server / host 

### from root user add ashu to docker group 

```
[root@docker-host ~]# usermod -aG docker  ashu 
```

### from client 

```
[ashu@docker-host ~]$ exit
logout
Connection to 54.198.64.250 closed.
fire@ashutoshhs-MacBook-Air ~ % 
fire@ashutoshhs-MacBook-Air ~ % ssh  ashu@54.198.64.250
ashu@54.198.64.250's password: 
Last login: Mon Jan 23 10:33:40 2023 from 103.59.75.183

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
7 package(s) needed for security, out of 8 available
Run "sudo yum update" to apply all updates.
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ docker  version 
Client:
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.18.6
 Git commit:        100c701
 Built:             Wed Sep 28 23:10:17 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server:
 Engine:
  Version:          20.10.17
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.6
  Git commit:       a89b842
  Built:            Wed Sep 28 23:10:55 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.8
  GitCommit:        9cd3357b7fd7218e4aec3eae239db1f68a5a6ec6
 runc:
  Version:          1.1.4
  GitCommit:        5fd4c4d144137e991c4acebb2146ab1483a97925
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```





