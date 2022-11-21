class update { 
  exec { 'apt-update':                    # exec resource named 'apt-update'
    command => '/usr/bin/apt-get update'  # command this resource will run
  }
}

include update #for all

# install curl package
package { 'curl':
  #require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

#install git package
package { 'git':
  #require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

exec { 'crl':
   require => Package['curl'],
   command => '/usr/bin/curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
}
class nodejs {
# install nodejs package
  package { 'nodejs':
    #require => Exec['apt-update'],        # require 'apt-update' before installing
    require => Exec['crl'],               # require 'crl' before
    ensure => installed,
  }
}
class mysql {
  package { ['mysql-server']:
    ensure => present,
    #require => Exec['apt-update'],
  }
  service { 'mysql':
    ensure => running,
    require => Package['mysql-server']
  }
}
node 'dbserver' {
  include mysql  
}
node 'appserver' {
  include nodejs
}
node 'default' { #update is in all of them so tst[0-2] are defined

}
