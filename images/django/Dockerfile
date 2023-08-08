FROM harbor.kubemsb.com/library/django:latest
LABEL AUTHOR="zhwq2012@gmail.com"

ADD code/ /data/code/
ADD startup.sh /data/startup.sh

EXPOSE 8000
CMD [ "/bin/bash", "/data/startup.sh" ]
