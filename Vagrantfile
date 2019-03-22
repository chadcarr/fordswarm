# Vagrant should be responsible merely for creating the machines and network,
# then minimal provisioning to allow habitat to load software (including chef
# recipes) from source control. This ensures that as much configuration
# management as possible is handled by habitat and chef, and doesn't get
# embedded in the Vagrant development environment by mistake.
# 1. define machines and network
# 2. minimal shell provisioning (bootstrap.sh) installs and runs habitat
# 3. all other configuration of nodes is handled by habitat and chef zero

net = "10.2.2"

# Create a manager and <workercount> workers starting at IP <net>.<starthost>
starthost = 2 # <net>.1 reserved for default gateway
manager = "#{net}.#{starthost}"
workercount = 2

Vagrant.configure("2") do |config|
    config.vm.box = "bento/opensuse-leap-42"

    config.vm.define "control-node", primary: true do |host|
        host.vm.provider "virtualbox" do |v|
            v.memory = 3072 # increase memory from 1024
        end
        host.vm.hostname = "control-node"
        host.vm.network "private_network", ip: "#{manager}"
        host.vm.provision "shell", path: "bootstrap.sh"
        host.vm.provision "chef_zero" do |chef|
            chef.nodes_path ="nodes"
            chef.add_recipe "bootstrap"
        end
    end

    (1..workercount).each() do |i|
        config.vm.define "work-node-#{i}" do |host|
            host.vm.hostname = "work-node-#{i}"
            host.vm.network "private_network", ip: "#{net}.#{starthost+i}"
            host.vm.provision "shell", path: "bootstrap.sh"
            host.vm.provision "chef_zero" do |chef|
                chef.json = {
                    "peers": [
                        "#{manager}"
                    ]
                }
                chef.nodes_path = "nodes"
                chef.add_recipe "bootstrap"
            end
        end
    end
end

# TODO:
# write bootstrap cookbook for basic chef zero provisioning by vagrant
# hab-sup.service template will start supervisors in a ring configuration
#   hab sup run --peer <manager> (--ring ???)
# write chef-base cookbook for continuous configuration management
# vagrant cookbook loads chef-base service from stable
#   hab svc load chadcarr/chef-base --channel stable --auto-update
# chef-base cookbook loads xmldump service from dev (with deps)
#   hab svc load chadcarr/xmldump --channel dev --auto-update
