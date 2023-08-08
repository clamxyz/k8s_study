#! /bin/bash

echo "Hello, nginx -- $HOSTNAME-$NGINX_VERSION" > /usr/share/nginx/html/index.html

nginx -g "daemon off;"