# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Vagrant box configuration
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Forward SSH agent to host
  config.ssh.forward_agent = true

  # Bootstrap script
  config.vm.provision :shell, :path => "vagrant/bootstrap.sh"

  # Port forwarding
  config.vm.network :forwarded_port, guest: 3000, host: 3000

end
