#! /bin/bash
# 通过命令行的方式执行k8s配置和docker, cri-dockerd的安装

for host in 192.168.159.{21..23};
do
   echo ==============================================================
   echo ====$host ===========================================
   chmod a+x 02_kubernetes_kernel_conf.sh 03_kubernetes_docker_install.sh
   scp 02_kubernetes_kernel_conf.sh root@$host:~/
   scp 03_kubernetes_docker_install.sh root@$host:~/
   scp cri-dockerd-0.3.4-3.el7.x86_64.rpm root@$host:~/
   ssh root@$host <<EOF
   ./02_kubernetes_kernel_conf.sh
   ./03_kubernetes_docker_install.sh
   timedatectl set-timezone Asia/Shanghai
   rpm -ivh cri-dockerd-0.3.4-3.el7.x86_64.rpm
   systemctl enable cri-docker && systemctl restart cri-docker
EOF
done
