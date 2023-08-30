#!/bin/bash
# 功能: 创建kubernetes专属的UA信息
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com
# 定制普通环境变量
ssl_dir='/etc/kubernetes/pki'
config_dir='/tmp'
kubernernetes_entry='https://192.168.159.100:6443'
target_type=(证书 配置 退出)
# 菜单
menu(){
  echo -e "\e[31m批量设定远程主机免密码认证管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 创建证书  2: 创建config  3: 退出操作 \e[0m"
  echo "====================================================="
}

# 创建证书文件
create_cert(){
  # 接收外部参数
  user_name="$1"
  group_name="$2"
  expire_time="$3"
  # 创建逻辑
  cd ${ssl_dir}
  (umask 077; openssl genrsa -out ${user_name}.key 2048)
  openssl req -new -key  ${user_name}.key -out ${user_name}.csr -subj "/CN=${user_name}/O=${group_name}"
  openssl x509 -req -in ${user_name}.csr -CA ./ca.crt  -CAkey ./ca.key  -CAcreateserial -out ${user_name}.crt -days ${expire_time}
}

# 创建认证配置文件
create_config(){
  # 接收外部参数
  conf_name="$1"
  user_name="$2"
  # 创建逻辑
  cd ${ssl_dir}
  kubectl config set-credentials ${user_name} --client-certificate=./${user_name}.crt --client-key=./${user_name}.key  --embed-certs=true --kubeconfig=${config_dir}/${conf_name}
  kubectl config set-cluster ${user_name} --server="${kubernernetes_entry}" --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --kubeconfig=${config_dir}/${conf_name}
  kubectl config set-context ${user_name}@${user_name} --cluster=${user_name} --user=${user_name} --kubeconfig=${config_dir}/${conf_name}
  kubectl config use-context ${user_name}@${user_name} --kubeconfig=${config_dir}/${conf_name}
}

# 帮助信息逻辑
Usage(){
  echo "请输入有效的操作id"
}
# 逻辑入口
while true
do
  menu
  read -p "请输入有效的操作id: " target_id
  if [ ${#target_type[@]} -ge ${target_id} ]
  then
    if [ ${target_type[${target_id}-1]} == "证书" ]
    then
       read -p "请输入有效的证书信息(用户名 组名 有效时间): " user_name group_name expire_time
       echo "开始创建证书操作..."
       create_cert ${user_name} ${group_name} ${expire_time}
    elif [ ${target_type[${target_id}-1]} == "配置" ]
    then
       read -p "请输入config文件名称(示例: zhangsan.conf): " conf_name
       echo "开始创建config操作..."
       create_config ${conf_name} ${user_name}
    elif [ ${target_type[${target_id}-1]} == "退出" ]
    then
       echo "开始退出管理界面..."
       exit
    fi
  else
    Usage
  fi
done
