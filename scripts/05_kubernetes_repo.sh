#! /bin/bash

if [ $# -ne 1 ];then
   echo "$0 k8s_version"
   exit
fi
K8S_VERSION=$1
# 关闭selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config 

# 关闭防火墙
systemctl stop firewalld 
systemctl disable firewalld

# 设置repo源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo 
[kubernetes] 
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64 
enabled=1
gpgcheck=0 
repo_gpgcheck=0 
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg 
EOF
sudo yum install -y kubelet-$K8S_VERSION-0 kubeadm-$K8S_VERSION-0 kubectl-$K8S_VERSION-0 --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

