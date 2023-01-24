## getting started

### Revision 

<img src="rev.png">

### solution of last day problem 

```
[ashu@docker-host ~]$ docker run --name ashuc1 -d  alpine sleep 1000 
f1650fc40662c8ceadb5452e6b4a212ad2dac711aa618f8f766414bafca2b57f
[ashu@docker-host ~]$ docker run --name ashuc2 -d  alpine sleep 1000 
0efcd48c8b29cfac246185d317f637372d849ebb628603a282b3ef9d3b2b758a
[ashu@docker-host ~]$ docker ps
CONTAINER ID   IMAGE     COMMAND        CREATED         STATUS         PORTS     NAMES
0efcd48c8b29   alpine    "sleep 1000"   2 seconds ago   Up 2 seconds             ashuc2
f1650fc40662   alpine    "sleep 1000"   8 seconds ago   Up 8 seconds             ashuc1
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ docker  exec -it ashuc1  sh 
/ # cd  /opt/
/opt # ls
/opt # echo hello world  >helloc1.txt 
/opt # ls
helloc1.txt
/opt # exit
[ashu@docker-host ~]$ 


```

### Docker cp to copy data 

```
[ashu@docker-host ~]$ ls
[ashu@docker-host ~]$ docker cp  ashuc1:/opt/helloc1.txt  . 
[ashu@docker-host ~]$ ls
helloc1.txt
[ashu@docker-host ~]$ 
[ashu@docker-host ~]$ docker  cp  helloc1.txt   ashuc2:/mnt/
[ashu@docker-host ~]$ docker  exec  ashuc2  ls  /mnt
helloc1.txt
[ashu@docker-host ~]$ 
```




