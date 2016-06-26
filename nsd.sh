#!/bin/sh

echo "
net.ipv4.conf.eth1.arp_announce = 2
net.ipv4.conf.eth1.arp_ignore = 2
" >> /etc/sysctl.conf
sysctl -p

# setting floating IP
echo "# for dns service ip
DEVICE=lo:0
IPADDR=192.168.100.53
NETMASK=255.255.255.255
ONBOOT=yes
" | tee /etc/sysconfig/network-scripts/ifcfg-lo:0
ifup lo


# install unbound
yum install -y sudo yum install epel-release.noarch
yum install -y nsd
echo "# NSD minimium config
server:
        ip-address: 192.168.100.53
        ip-address: 192.168.100.11
        ip-address: 127.0.0.1
        database: \"\"
remote-control:
        control-enable: yes
" | tee /etc/nsd/nsd.conf
chkconfig nsd on
service nsd start
