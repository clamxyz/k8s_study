#! /bin/bash

echo "Hello, tomcat! $HOSTNAME-$TOMCAT_VERSION" > /usr/local/tomcat/webapps/ROOT/index.jsp

catalina.sh run
