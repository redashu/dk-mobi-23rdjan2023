FROM oraclelinux:8.4
LABEL name="ashutoshh"
LABEL email="ashutoshh@linux.com"
RUN yum install java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 wget -y && mkdir /app
WORKDIR /app
RUN wget https://get.jenkins.io/war-stable/2.375.2/jenkins.war
# downloading jenkins war file 
EXPOSE 8080 
# by default letting docker engine know about port 
CMD ["java","-jar","jenkins.war"]