kernel_version=$(uname -r|cut -d- -f1)
if [ "$kernel_version" = "5.4.255" ];then 
   echo 内核已经是符合要求的版本了，不需要升级了
   exit
fi
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
# 安装长期支持版本(5.4.218)
yum --enablerepo=elrepo-kernel install kernel-lt -y
# 设置 GRUB 默认的内核版本
sed -i 's#GRUB_DEFAULT=.*#GRUB_DEFAULT=0#' /etc/default/grub

# 重新配置grub
grub2-mkconfig -o /boot/grub2/grub.cfg

