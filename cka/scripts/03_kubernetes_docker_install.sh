#!/bin/bash
# 功能: 安装部署Docker容器环境
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 准备工作

# 软件源配置
softs_base(){
  # 安装基础软件
  yum install -y yum-utils device-mapper-persistent-data lvm2
  # 定制软件仓库源
  yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  # 更新软件源
  #systemctl restart network
  yum makecache fast
}

# 软件安装
soft_install(){
  # 安装最新版的docker软件
  #yum install -y docker-ce
  yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  # 重启docker服务
  systemctl restart docker
  systemctl enable docker
}

# 加速器配置
speed_config(){
  # 定制加速器配置
cat > /etc/docker/daemon.json <<-EOF
{
  "registry-mirrors": [
    ""https://w3yz7d67.mirror.aliyuncs.com"",
    "http://74f21445.m.daocloud.io",
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ],
  "insecure-registries": ["192.168.159.10:80", "harbor.kubemsb.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
  # 重启docker服务
  systemctl restart docker
}

# 环境监测
docker_check(){
  process_name=$(docker info | grep 'p D' | awk '{print $NF}')
  [ "${process_name}" == "systemd" ] && echo "Docker软件部署完毕" || (echo "Docker软件部署失败" && exit)
}

# 软件部署
main(){
  softs_base
  soft_install
  speed_config
  docker_check
}

# 调用主函数
main
