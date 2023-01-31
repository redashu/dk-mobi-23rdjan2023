## getting started

### REvision 

### taking webapp to containerize and test it 

```
[ashu@docker-host ashu-apps]$ cd  ashu-compose-examples/
[ashu@docker-host ashu-compose-examples]$ ls
ashu-app.yaml  docker-compose.yaml  myapp  tomcat.dockerfile  tomcat.yaml
[ashu@docker-host ashu-compose-examples]$ git clone https://github.com/microsoft/project-html-website.git
Cloning into 'project-html-website'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 24 (delta 0), reused 3 (delta 0), pack-reused 19
Receiving objects: 100% (24/24), 465.86 KiB | 29.12 MiB/s, done.
[ashu@docker-host ashu-compose-examples]$ ls
ashu-app.yaml  docker-compose.yaml  myapp  project-html-website  tomcat.dockerfile  tomcat.yaml
[ashu@docker-host ashu-compose-examples]$ 


```

### Using apache httpd for docker based app hosting 

<img src="httpd.png">

### above code project-html-website  -- with Dockerfile and .dockerignore

```
FROM oraclelinux:8.4 
LABEL name="ashutoshh"
LABEL email="ashutoshh@linux.com"
RUN yum install httpd -y 
ADD project-html-website /var/www/html/
# COPY and add both are same while add can accept data from URL also 
ENTRYPOINT [ "httpd","-DFOREGROUND" ]
# like CMD we can use ENTRYPOINT 
```

### .dockerignore 

```
project-html-website/.git
project-html-website/*.md
project-html-website/LICENSE
```

### Docker compose for above example 

```
version: '3.8'
services:
  ashu-ui-app:
    image: docker.io/dockerashu/ashu-mobiwebapp:v1 
    build:
      context: . 
      dockerfile: httpd.dockerfile
    container_name: ashuwebc1
    restart: always 
    ports:
    - 1234:80 
```

### lets test it 

```
[ashu@docker-host ashu-compose-examples]$ ls
ashu-app.yaml        httpd-compose.yaml  myapp                 tomcat.dockerfile
docker-compose.yaml  httpd.dockerfile    project-html-website  tomcat.yaml
[ashu@docker-host ashu-compose-examples]$ docker-compose -f httpd-compose.yaml  --build up -d 
unknown flag: --build
[ashu@docker-host ashu-compose-examples]$ docker-compose -f httpd-compose.yaml up -d  --build 
[+] Building 10.9s (6/8)                                                                                                       
 => [internal] load build definition from httpd.dockerfile                                                                0.0s
 => => transferring dockerfile: 331B                                                                                      0.0s
 => [internal] load .dockerignore                                                                                         0.0s
 => => transferring context: 120B                                                                                         0.0s
 => [internal] load metadata for docker.io/library/oraclelinux:8.4                                                        0.3s
 => [auth] library/oraclelinux:pull token for registry-1.docker.io                                                        0.0s
 => CACHED [1/3] FROM docker.io/library/oraclelinux:8.4@sha256:b81d5b0638bb67030b207d28586d0e714a811cc612396dbe3410db406  0.0s
 => => resolve docker.io/library/oraclelinux:8.4@sha256:b81d5b0638bb67030b207d28586d0e714a811cc612396dbe3410db406998b3ad  0.0s
 => [internal] load build context                                                                                         0.0s
 => => transferring context: 823.15kB                                                                                     0.0s
 => [2/3] RUN yum install httpd -y                                                                                       10.5s
 => => # Oracle Linux 8 BaseOS Latest (x86_64)            70 MB/s |  54 MB     00:00                                          

```

### 

