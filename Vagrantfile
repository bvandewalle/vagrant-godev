# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
    vb.memory = "4096"
    vb.cpus = 4
  end

  config.vm.box = "ubuntu/xenial64"

  config.vm.define "linuxdev" do |c|

    c.vm.provision "shell", inline: <<-SHELL
      echo "ubuntu:ubuntu" | sudo chpasswd
    SHELL

    c.vm.hostname = "linuxdev"
    c.vm.network "private_network", ip: "192.168.100.10"
    c.vm.synced_folder ENV['GOPATH'], "/home/ubuntu/gopath"
    c.vm.provision "shell", env: {"SSVMIP" => "192.168.100.1"}, path: "./bootstrap.sh"
  end


end
