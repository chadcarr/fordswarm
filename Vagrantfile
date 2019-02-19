net = "10.2.2"

# Create a manager and <workercount> workers starting at IP <net>.<starthost>
starthost = 2 # <net>.1 reserved for default gateway
manager = "#{net}.#{starthost}"
workercount = 1

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.define "control-node", primary: true do |host|
        host.vm.provider "virtualbox" do |v|
            v.memory = 3072
        end
        host.vm.hostname = "control-node"
        host.vm.network "private_network", ip: "#{manager}"
        host.vm.provision "shell", path: "./bootstrap.sh", args: "controller"
        host.vm.provision "puppet" do |puppet|
            puppet.options = "--verbose --debug"
        end
#        host.vm.provision "docker"
#        host.vm.provision "docker_compose"
        # Initialize the cluster and make the join token available to the work nodes
#        host.vm.provision "shell", inline: "docker swarm init --advertise-addr=#{manager}"
#        host.vm.provision "shell", inline: "docker swarm join-token -q worker > /vagrant/swarm-token"
        # Create a temporary net-accessible registry for deploying stack to work nodes - TODO destroy or make secure
#        host.vm.provision "shell", inline: "docker service create --name registry -p 5000:5000 registry"
        # Build and run stack on the control node, push to the temp registry
#        host.vm.provision "docker_compose" , project_name: "puppet-stack", yml: "/vagrant/docker-compose.yml", rebuild: true, run: "always", command_options: {push: ""}
        # Deploy stack to the cluster
#        config.vm.provision "shell", inline: "docker stack deploy -c /vagrant/docker-compose.yml puppet-stack", run: "always"
    end
    (1..workercount).each() do |i|
        config.vm.define "work-node-#{i}" do |host|
            host.vm.hostname = "work-node-#{i}"
            host.vm.network "private_network", ip: "#{net}.#{starthost+i}"
            host.vm.provision "shell", path: "./bootstrap.sh", args: "worker"
            host.vm.provision "puppet" do |puppet|
                puppet.options = "--verbose --debug"
            end
#            host.vm.provision "docker"
#            host.vm.provision "docker_compose"
#            host.vm.provision "shell", inline: "docker swarm join --token=`cat /vagrant/swarm-token` #{manager}"
        end
    end
end
