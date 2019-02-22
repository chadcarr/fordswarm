class role::controller {
  include profile::dockerd
  # include profile::dns_server
  # include profile::swarm_manager
}

class role::worker {
  include profile::dockerd
  # include profile::swarm_worker
}
node /^control/ {
  include role::controller
}

node /^work/ {
  include role::worker
}
