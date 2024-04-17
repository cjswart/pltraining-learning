# Add default memory settings after PE install

class learning::set_defaults {
  exec { 'mkdir -p /etc/puppetlabs/code':
    path   => '/bin',
    before => File['/etc/puppetlabs/puppet/hiera.yaml','/etc/puppetlabs/code/hieradata']
  }
  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => file,
    source  => 'puppet:///modules/learning/hiera.yaml',
  }
  file { '/etc/puppetlabs/code/hieradata':
    ensure => directory,
  }
  file { '/etc/puppetlabs/code/hieradata/defaults.yaml':
    ensure => file,
    source => 'puppet:///modules/learning/defaults.yaml',
    require => File['/etc/puppetlabs/code/hieradata'],
  }
  user { 'root':
    ensure   => present,
    password => pw_hash('puppetlabs', 'SHA-512', '71EE723C'),
    uid      => 0,
    gid      => 0,
    home     => '/root',
    shell    => '/bin/bash',
  }
  user { 'adminuser':
    ensure   => present,
    password => pw_hash('#BeterInternet', 'SHA-512', '71EE723C'),
  }
}
