# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2 
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
  end

  config.vm.provision "shell", inline: "sudo apt-get -y install ca-certificates"
  config.vm.provision "shell", path: "scripts/apt.postgresql.org.sh"
  config.vm.provision "shell", path: "scripts/install.sh"
  config.vm.provision "shell", privileged: false, path: "scripts/rvm.sh"
  config.vm.provision "shell", privileged: false, path: "scripts/ruby.sh"
end
