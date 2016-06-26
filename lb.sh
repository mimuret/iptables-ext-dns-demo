#!/bin/sh

echo "# for dns service ip
DEVICE=eth1:0
IPADDR=192.168.100.53
NETMASK=255.255.255.0
ONBOOT=yes
" | sudo tee /etc/sysconfig/network-scripts/ifcfg-eth1:0
sudo ifup eth1

sudo yum install -y git ipvsadm kernel kernel-devel kernel-headers

git clone https://github.com/mimuret/iptables-ext-dns
cd iptables-ext-dns
sudo ./install-dependencies.sh
./autogen.sh
./configure
make
sudo make install

iptables -t mangle -A PREROUTING -m dns --rd -j MARK --set-xmark 0x1/0xffffffff
iptables -t mangle -A PREROUTING -m dns ! --rd -j MARK --set-xmark 0x2/0xffffffff
iptables-save > /etc/sysconfig/iptables

ipvsadm -A -f 1 -s rr
ipvsadm -a -f 1 -r 192.168.100.12
ipvsadm -A -f 2 -s rr
ipvsadm -a -f 2 -r 192.168.100.11
ipvsadm-save > /etc/sysconfig/ipvsadm

chkconfig ipvsadm on
