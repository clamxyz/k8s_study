from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
import os
def index(request):
    # 获取系统环境变量
    hostname=os.environ.get("HOSTNAME")
    version=os.environ.get("DJANGO_VERSION")
    # 定制专属的信息输出
    message="{}, {}-{}\n".format("Hello Django", hostname, version)
    return HttpResponse(message)

