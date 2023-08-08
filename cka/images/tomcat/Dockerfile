FROM harbor.kubemsb.com/library/tomcat:latest
LABEL AUTHOR="zhwq2012@gmail.com"
LABEL VERSION="0.1"

RUN mv /usr/local/tomcat/webapps /usr/local/tomcat/webapps.bak \
    && mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps

ADD startup.sh /data/startup.sh

CMD [ "/bin/bash", "/data/startup.sh" ]
