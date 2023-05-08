class learning (
  $git_branch         = 'master',
  $content_repo_owner = 'cjswart',
  $content_repo_name  = 'puppet-quest-guide',
  $include_abalone    = false,
  $autosign_value     = false,
) {

  class { 'learning::quest_guide':
    git_branch         => $git_branch,
    content_repo_owner => $content_repo_owner,
    content_repo_name  => $content_repo_name,
  }

  ## Install learning VM specific things
  include learning::install
  class { 'learning::quest_tool':
    content_repo_dir => "/usr/src/${content_repo_name}",
  }
  include learning::ssh
  include learning::set_defaults

  if $include_abalone { include learning::abalone }

  if $autosign_value {
    file_line { "autosign":
      path => '/etc/puppetlabs/puppet/autosign.conf',
      line => $autosign_value,
    }
  }
  # allow puppetserver console and guest book trafic
  firewalld_port { 'Open port 80 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 80,
    protocol => 'tcp',
  }
  firewalld_port { 'Open port 443 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 443,
    protocol => 'tcp',
  }
  include learning::gitea
}
