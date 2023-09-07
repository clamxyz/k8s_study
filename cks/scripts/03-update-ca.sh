for host in 22 31 32;
do
  scp ./ca.crt root@192.168.159.$host:/etc/pki/ca-trust/source/anchors
  ssh root@192.168.159.$host update-ca-trust
done
