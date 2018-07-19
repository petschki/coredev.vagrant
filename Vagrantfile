# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("1") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

    config.vm.forward_port 8080, 8080

    # Run apt-get update as a separate step in order to avoid
    # package install errors
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "aptgetupdate.pp"
    end

    # ensure we have the packages we need
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "plone.pp"
    end

    # Create a Putty-style keyfile for Windows users
    config.vm.provision :shell do |shell|
        shell.path = "manifests/host_setup.sh"
        shell.args = RUBY_PLATFORM
    end

    # install Plone
    config.vm.provision :shell do |shell|
        shell.path = "manifests/install_plone.sh"
        shell.args = RUBY_PLATFORM
    end

    # install Plone PY3
    config.vm.provision :shell do |shell|
        shell.path = "manifests/install_plone_py3.sh"
        shell.args = RUBY_PLATFORM
    end
end
