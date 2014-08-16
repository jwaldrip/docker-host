# -*- mode: ruby -*-
# # vi: set ft=ruby :
$: << File.dirname(__FILE__)
require 'lib/config.rb'

Vagrant.configure("2") do |config|
  config.vm.box_url = "http://#{$coreos_update_channel}.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"
  config.vm.box = "coreos-#{$coreos_update_channel}"
  config.vm.box_version = $coreos_version

  config.vm.provider :vmware_fusion do |vb, override|
    override.vm.box_url = "http://#{$coreos_update_channel}.release.core-os.net/amd64-usr/current/coreos_production_vagrant_vmware_fusion.json"
  end

  # Fix docker not being able to resolve private registry in VirtualBox
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.memory = $vb_memory
    vb.cpus = $vb_cpus
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.define "docker" do |config|

    # Set the hostname
    config.vm.hostname = "docker.jasonwaldrip.com"

    ip = "10.255.255.254"
    config.vm.network :private_network, ip: ip

    # workaround missing /etc/hosts
    config.vm.provision :shell, inline: "echo #{ip} #{config.vm.hostname} > /etc/hosts", privileged: true

    # workaround missing /etc/environment
    config.vm.provision :shell, inline: 'touch /etc/environment', privileged: true

    # Copy && Run Cloud Config
    config.vm.provision :file, source: CloudInitBuilder::DATAFILE, destination: '/tmp/vagrantfile-user-data'
    config.vm.provision :shell, inline: 'mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/', privileged: true

  end
end
