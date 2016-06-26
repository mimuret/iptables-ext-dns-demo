# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/6"
  config.vm.boot_timeout = 120
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--memory", "512"]
  end
  config.vm.define "client" do |node|
    node.vm.hostname = "client.lab.mimuret.net."
    node.vm.network "private_network", ip: "192.168.100.10"
    node.vm.provision "shell", path: "client.sh"
  end
  config.vm.define "nsd" do |node|
    node.vm.hostname = "nsd.lab.mimuret.net."
    node.vm.network "private_network", ip: "192.168.100.11"
    node.vm.provision "shell", path: "nsd.sh"
  end
  config.vm.define "unbound" do |node|
    node.vm.hostname = "unbound.lab.mimuret.net."
    node.vm.network "private_network", ip: "192.168.100.12"
    node.vm.provision "shell", path: "unbound.sh"
  end
  config.vm.define "lb" do |node|
    node.vm.hostname = "lb.lab.mimuret.net."
    node.vm.network "private_network", ip: "192.168.100.13"
    node.vm.provision "shell", path: "lb.sh"
  end
end
