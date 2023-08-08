#! /bin/bash
COLOR="\033[32m"
CEND="\033[0m"
echo -e $COLOR "检查节点$(hostname)环境$CEND"
if [ -f /usr/bin/expect ];then
   echo -e $COLOR "节点环境条件满足" $CEND
else
   echo -e $COLOR "节点环境条件不满足，正在安装软件" $CEND
   yum install -y expect
fi
echo -e $COLOR "开始复位节点$(hostname)...$CEND"
expect -c ' 
spawn kubeadm reset --cri-socket=unix:///var/run/cri-dockerd.sock
expect {
	"y/N" {send "y\n";exp_continue}
	"y/N" {send "y\n"} 
}'
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
if [ -f /usr/sbin/ipvsadm ];then
   ipvsadm --clear
fi
rm -rf /etc/cni/net.d/*
rm -rf /etc/kubernetes
rm -rf /var/lib/etcd
rm -rf $HOME/.kube
echo -e "$COLOR 复位节点$(hostname)完成$CEND"

