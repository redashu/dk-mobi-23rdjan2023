## getting started

## Docker volume usage 

### Dockerfile 

```
FROM centos
LABEL name="ashutoshh"
COPY datagen.sh /root/
WORKDIR /root
RUN chmod +x datagen.sh
ENTRYPOINT [ "./datagen.sh" ]
# using ENTRYPOINT instead of CMD 
```

### script for data generation 

```
#!/bin/bash
while [ true ]
do
    echo "Hello i am data by ashu developer .." >>/opt/mydata/ashu.txt
    date >>/opt/mydata/ashu.txt 
    sleep 15 
done
```

### using volume with compose 

```
version: '3.8'
networks: # to create network like docker network create ashubrx1 
  ashubrx1:
volumes: # creating volume like -- docker volume create ashu-volx1 
  ashu-volx1: 
services:
  ashudata-svc1:
    image: ashudata:testv1 
    build: 
      context: .
      dockerfile: Dockerfile 
    container_name: ashudatac1 
    volumes: # using volumes 
    - ashu-volx1:/opt/mydata/
    networks: # using network 
      - ashubrx1 
```

### lets run it 

```

```


