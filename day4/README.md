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


