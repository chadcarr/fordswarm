class profile::puppet_server {
  package { 'puppetserver': ensure => present }
  service { 'puppetserver':
    ensure => running,
    enable => true
  }
  # install r10k and Puppetfile
  # copy site manifests
}

class profile::puppet_agent {
  host { 'puppet':
    ensure => present,
    ip => $puppetserver,
    target => '/etc/hosts'
  }
  service { 'puppet':
    ensure => running,
    enable => true
  }
}

class profile::common {
  package { 'ntp': ensure => present }
  service { 'ntp':
    ensure => running,
    enable => true
  }
}

class role::controller {
  include profile::common
  include profile::puppet_server
  include profile::puppet_agent
}

class role::worker {
  include profile::common
  include profile::puppet_agent
}

node /^control/ {
  include role::controller
}

node /^work/ {
  include role::worker
}
