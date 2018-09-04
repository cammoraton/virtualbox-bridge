# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Don't share the default synced folder
  config.vm.synced_folder "", "/vagrant", disabled: true

  config.vm.box = "puppetserver"
  config.vm.box_check_update = false
end
