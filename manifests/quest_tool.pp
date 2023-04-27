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

  package { ['git', 'gcc', 'ruby', 'ruby-devel']:
    ensure => present,
  }
  -> package { 'timers':
    ensure   => '4.1.2',
    provider => gem,
  }
  -> package { 'concurrent-ruby':
    ensure   => '1.1.7',
    provider => gem,
  }
  -> package { 'minitest':
    ensure   => '5.11.1',
    provider => gem,
  }
  -> package { 'hitimes':
    ensure   => '1.3.0',
    provider => gem,
  }
  -> package { 'quest':
    ensure   => '1.2.2',
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
