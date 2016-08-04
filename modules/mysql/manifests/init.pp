# Install the MySQL relational database
class mysql (
  $root_pass = 'root'
) {
  case $::operatingsystem {
    redhat, centos: {
      $servicename = 'mysqld'
      $pkgname = 'mysql-server'
      $config = 'my.cnf.el'
      $fs_name = 'my.cnf'
    }
    debian, ubuntu: {
      $servicename = 'mysql'
      $config = 'my.cnf.debian'
      $fs_name = 'mysql/my.cnf'
      $pkgname = 'mysql-community-server'

      exec { 'wget https://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb && dpkg -i mysql-apt-config_0.7.3-1_all.deb && apt update':
        before  => Package['mysql'],
        creates => '/etc/apt/sources.list.d/mysql.list',
      }

    }
    default: { fail('Unrecognized operating system.') }
  }

  package {'mysql':
    ensure => 'latest',
    name   => $pkgname,
    before => Service['mysql']
  }

  service {'mysql':
    ensure     => running,
    name       => $servicename,
    enable     => true,
    hasrestart => true,
  }

  exec {'root_pass':
    unless  => "mysql -u root -p'${root_pass}' -e 'SHOW DATABASES'",
    command => "mysqladmin -u root password '${root_pass}'",
    require => Service['mysql']
  }
}
