class learning::quest_tool (
  $content_repo_dir = '/usr/src/puppet-quest-guide'
) {

  $home = '/root'

  package { 'tmux':
    ensure  => 'present',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0744',
  }

  file { "${home}/.tmux.conf":
    ensure => file,
    source => 'puppet:///modules/learning/tmux.conf',
  }

  file { "${home}/.bashrc.learningvm":
    ensure => file,
    source => 'puppet:///modules/learning/bashrc.learningvm',
  }
  file { "${home}/.bashrc.puppet":
    ensure => file,
    source => 'puppet:///modules/learning/bashrc.puppet',
  }
  file { "${home}/.bashrc":
    ensure => file,
    source => 'puppet:///modules/learning/bashrc',
  }

  package { ['git', 'gcc', 'ruby', 'ruby-devel']:
    ensure => present,
  }

  package { 'concurrent-ruby':
    ensure   => '1.1.7',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'minitest':
    ensure   => '5.11.1',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'hitimes':
    ensure   => '1.3.0',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'timers':
    ensure   => '4.1.2',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'unf_ext':
    ensure   => '0.0.7.7',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'unf':
    ensure   => '0.1.4',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'domain_name':
    ensure   => '0.5.20180417',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'rest-client':
    ensure   => '2.0.2',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'rack':
    ensure   => '1.6.4',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'thin':
    ensure   => '1.7.2',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'public_suffix':
    ensure   => '2.0.5',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'addressable':
    ensure   => '2.7.0',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'sinatra-websocket':
    ensure   => '0.3.1',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'rake':
    ensure   => '10.5.0',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'rack-test':
    ensure   => '0.6.3',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'puppet-lint':
    ensure   => '2.4.2',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'nokogiri':
    ensure   => '1.6.8.1',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'jgrep':
    ensure   => '1.5.4',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'net-telnet':
    ensure   => '0.1.1',
    command  => '/bin/gem',
    provider => gem,
  }
  -> package { 'quest':
    ensure   => '1.2.2',
    command  => '/bin/gem',
    provider => gem,
  }

  file { '/etc/systemd/system/quest.service':
    ensure  => file,
    content => epp('learning/quest.service.epp', {'test_dir' => "${content_repo_dir}/tests"}),
    mode    => '0644',
  }

  service { 'quest':
    provider => systemd,
    ensure   => 'running',
    enable   => true,
    require  => [Package['quest'], File['/etc/systemd/system/quest.service']],
  }

}
