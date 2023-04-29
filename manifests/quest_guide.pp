class learning::quest_guide (
  $git_branch = 'master',
  $content_repo_owner = 'cjswart',
  $content_repo_name  = 'puppet-quest-guide',
) {

  $content_repo_dir   = "/usr/src/${content_repo_name}"

  include learning::quest_guide_server

  # Nodejs and npm are required for the GitBook quest guide setup
  class { '::nodejs':
    nodejs_dev_package_ensure => 'present',
    npm_package_ensure        => 'present',
    repo_class                => '::epel',
  }

  file { '/usr/src/puppet-quest-guide/package.json':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => '{"resolutions":{"graceful-fs":"4.2.4"},"devDependencies":{"graceful-fs":"^4.2.4"}}',
  }
  package { 'graceful-fs':
    ensure   => 4.2.4,
    provider => 'npm',
    install_options => ['--save-dev'].
    require  => Package['npm'],
  }
  # Install gitbook-cli
  package { 'gitbook-cli':
    ensure   => 2.1.2,
    provider => 'npm',
    require  => Package['npm'],
  }

  # Grab the puppet-quest-guide repository so we can render it
  # as html with gitbook
  vcsrepo { $content_repo_dir:
    ensure   => present,
    provider => git,
    revision => $git_branch,
    source   => "https://github.com/${content_repo_owner}/${content_repo_name}.git",
  }

  # This builds html from the quest guide repository
  exec { 'gitbook build':
    command => '/usr/local/bin/gitbook install && /usr/local/bin/gitbook build',
    cwd     => $content_repo_dir,
    creates => "${content_repo_dir}/_book",
    require => [Vcsrepo[$content_repo_dir], Package['gitbook-cli']],
  }

  file { "/var/www/quest":
    ensure  => symlink,
    owner   => 'nginx',
    group   => 'nginx',
    target  => "${content_repo_dir}/_book",
    require => Exec['gitbook build'],
  }

}
