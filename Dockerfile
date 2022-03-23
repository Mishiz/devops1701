FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y default-jdk

EXPOSE 8080

WORKDIR /opt

RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.77/bin/apache-tomcat-8.5.77.tar.gz \
    && mkdir ./tomcat \
    && tar -xzvf apache-tomcat-8.5.76.tar.gz -C tomcat --strip-components=1 \
    && rm -rf ./tomcat/webapps/*

ADD ROOT.war /opt/tomcat/webapps/ROOT.war

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
