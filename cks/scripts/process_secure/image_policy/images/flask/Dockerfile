FROM harbor.kubemsb.com/library/python
LABEL MAINTANER zhwq2012@gmail.com
RUN useradd python -d /data && pip install flask
RUN mkdir -p /data/server/image_check/cert && chown -R python /data/
ADD conf/main.py /data/server/image_check/main.py
EXPOSE 8080
VOLUME /data/server/image_check
USER python
CMD ["python", "/data/server/image_check/main.py"]
