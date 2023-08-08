#!/bin/bash
# 功能: 获取kubernetes依赖的Docker镜像文件
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com
# 定制普通环境变量
ali_mirror='registry.aliyuncs.com'
harbor_mirror='harbor.kubemsb.com'
harbor_repo='google_containers'

# 环境定制
kubernetes_image_get(){
  # 获取脚本参数
  kubernetes_version="$1"
  # 获取制定kubernetes版本所需镜像
  images=$(kubeadm config images list --kubernetes-version=${kubernetes_version} | awk -F "/" '{print $NF}')

  # 获取依赖镜像
  for i in ${images}
  do
    docker pull ${ali_mirror}/${harbor_repo}/$i
    docker tag ${ali_mirror}/${harbor_repo}/$i  ${harbor_mirror}/${harbor_repo}/$i
    docker rmi ${ali_mirror}/${harbor_repo}/$i
  done
}

# 脚本的帮助
Usage(){
  echo "/bin/bash $0 "
}

# 脚本主流程
if [ $# -eq 0 ]
then
   read -p "请输入要获取kubernetes镜像的版本(示例: v1.23.9): " kubernetes_version
   kubernetes_image_get ${kubernetes_version}
else
   Usage
fi
