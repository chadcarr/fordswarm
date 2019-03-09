# Vagrant should be responsible merely for creating the machines and network,
# then minimal provisioning to allow habitat to load software (including chef
# and configuration recipes) from source control. This ensures that as much
# configuration management as possible is handled by habitat and chef, and
# doesn't get embedded in the Vagrant development environment by mistake.
# 1. define machines and network
# 2. minimal shell provisioning (bootstrap.sh) hands off to habitat
# 3. all other configuration of nodes is handled by habitat and chef solo

net = "10.2.2"

# Create a manager and <workercount> workers starting at IP <net>.<starthost>
starthost = 2 # <net>.1 reserved for default gateway
manager = "#{net}.#{starthost}"
workercount = 2

Vagrant.configure("2") do |config|
    # config.vm.box = "ubuntu/bionic64"
    config.vm.box = "bento/opensuse-leap-42"

    config.vm.define "control-node", primary: true do |host|
        # host.vm.provider "virtualbox" do |v|
        #     v.memory = 3072 # increase memory for puppetserver
        # end
        host.vm.hostname = "control-node"
        host.vm.network "private_network", ip: "#{manager}"
        host.vm.provision "shell", path: "bootstrap.sh"
        # host.vm.provision "chef_solo" do |chef|
        #     chef.json = {
        #         bootstrap_chef: {
        #             chefserver: "#{manager}"
        #         }
        #     }
        #     chef.run_list = [ "bootstrap-chef" ]
        # end
    end

    (1..workercount).each() do |i|
        config.vm.define "work-node-#{i}" do |host|
            host.vm.hostname = "work-node-#{i}"
            host.vm.network "private_network", ip: "#{net}.#{starthost+i}"
            host.vm.provision "shell", path: "bootstrap.sh"
            # host.vm.provision "chef_solo" do |chef|
            #     chef.json = {
            #         bootstrap_chef: {
            #             chefserver: "#{manager}"
            #         }
            #     }
            #     chef.add_recipe "bootstrap-chef"
            # end
        end
    end
end
