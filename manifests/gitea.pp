# install gitea
class learning::gitea {
  include mysql::server
  mysql::db { 'gitea':
    ensure   => present,
    user     => 'gitea',
    password => 'time2value',
    host     => '127.0.0.1',
    grant    => [ 'ALL' ],
  }
  class {'gitea':
    version => '1.6.0',
    checksum => '9c66d4207b49309de9d4d750bab1090c15bf6de5d99e0de819f5215cba35d2cb',
  }

}
