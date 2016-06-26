# iptables-ext-dnsset-demo
DNS Summer Day 2016のLTで発表した時のdemoとほぼ同じもの。

試し方
===================
- virtualbox + vagrantをインストールする。

```bash
git clone https://github.com/mimuret/iptables-ext-dns-demo
cd iptables-ext-dns-demo
vagrant up

vagrant ssh client

dig @192.168.100.53 chaos txt hostname.bind +norec 
dig @192.168.100.53 chaos txt hostname.bind +rec

```

構成
======
- client digするだけのもの
- lb iptables(xt_dns+MARK),ip_vsでrdbitを見てフォワードさせるもの。今回のメイン
- nsd nsdが動いてるだけ
- unbound unboundが動いてるだけ
