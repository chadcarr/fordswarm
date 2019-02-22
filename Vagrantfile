net = "10.2.2"

# Create a manager and <workercount> workers starting at IP <net>.<starthost>
starthost = 2 # <net>.1 reserved for default gateway
manager = "#{net}.#{starthost}"
workercount = 2

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.define "control-node", primary: true do |host|
        host.vm.provider "virtualbox" do |v|
            v.memory = 3072 # increase memory for puppetserver
        end
        host.vm.hostname = "control-node"
        host.vm.network "private_network", ip: "#{manager}"
        host.vm.provision "shell", path: "bootstrap.sh"
        host.vm.provision "puppet" do |puppet|
            puppet.manifest_file = "bootstrap-puppet.pp"
            puppet.facter = {
                "puppetserver" => "#{manager}"
            }
            #puppet.options = "--verbose --debug"
        end
        # We want to trigger the ca sign on the puppetserver after all the
        # agents have sent their keys - this does not work TODO
        # host.trigger.after :up do |trigger|
        #     trigger.run_remote = { inline: "puppetserver ca sign --all" }
        # end
    end

    (1..workercount).each() do |i|
        config.vm.define "work-node-#{i}" do |host|
            host.vm.hostname = "work-node-#{i}"
            host.vm.network "private_network", ip: "#{net}.#{starthost+i}"
            host.vm.provision "shell", path: "bootstrap.sh"
            host.vm.provision "puppet" do |puppet|
                puppet.manifest_file = "bootstrap-puppet.pp"
                puppet.facter = {
                    "puppetserver" => "#{manager}"
                }
                #puppet.options = "--verbose --debug"
            end
        end
    end
end
