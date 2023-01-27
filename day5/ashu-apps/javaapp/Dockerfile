FROM openjdk 
# FROM is automatically will pull image from docker hub 
LABEL name=ashutoshh
LABEL email=ashutoshh@linux.com 
# Label is an optional field but you can use to share image developer info 
RUN mkdir /ashucode 
# RUn will be executing any shell command to image during build time 
COPY ashu.java /ashucode/
# copy data from docker client to docker server during image build time 
WORKDIR /ashucode
# change directory of this image during build time 
RUN javac ashu.java 
# compiling java code to create class file 
CMD  ["java","ashu"]
# this will be automatically executed whenever someone create container 
# from this image 
# CMD is used to define the default process of container 