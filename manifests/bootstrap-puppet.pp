# Puppet provisioner for vagrant - just enough to get puppet running in a
# server-agent arrangement so that r10k and the control repo can take over.

class profile::puppet_server {
  package { 'puppetserver': ensure => present }
  service { 'puppetserver':
    ensure => running,
    enable => true
  }
  package { 'r10k':
    ensure => present,
    provider => 'puppet_gem'
  }
  file { '/etc/puppetlabs/r10k':
    ensure => directory
  }
  file { '/etc/puppetlabs/r10k/r10k.yaml':
    ensure => file,
    source => '/vagrant/r10k.yaml'
  }
  exec { '/opt/puppetlabs/puppet/bin/r10k deploy environment -p': }
}

class profile::puppet_agent {
  host { 'puppet':
    ensure => present,
    ip => $master,
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
