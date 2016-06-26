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
yum install -y unbound
chkconfig unbound on
echo "# unbound minimum conf
server:
	verbosity: 1
	num-threads: 2

	interface: 192.168.100.53
	interface: 192.168.100.12
	interface: 127.0.0.1
	
	outgoing-num-tcp: 100
	incoming-num-tcp: 100

	edns-buffer-size: 1280
	msg-cache-size: 32M
	rrset-cache-size: 64m

	access-control: 10.0.0.0/8 allow
	access-control: 172.16.0.0/12 allow
	access-control: 192.168.0.0/16 allow
	access-control: 127.0.0.0/8 allow
	access-control: ::1 allow

	username: \"unbound\"
	directory: \"/etc/unbound\"

	pidfile: \"/var/run/unbound/unbound.pid\"

# Remote control config section.
remote-control:
	control-enable: yes
	server-key-file: \"/etc/unbound/unbound_server.key\"
	server-cert-file: \"/etc/unbound/unbound_server.pem\"
	control-key-file: \"/etc/unbound/unbound_control.key\"
	control-cert-file: \"/etc/unbound/unbound_control.pem\"
" | tee /etc/unbound/unbound.conf

service unbound start
