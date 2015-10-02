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
      $pkgname = 'mysql-server-5.5'
      $config = 'my.cnf.debian'
      $fs_name = 'mysql/my.cnf'
    }
  default: { fail('Unrecognized operating system.') }
  }

  package {'mysql':
    ensure => 'latest',
    name   => $pkgname,
    before => File['my.cnf']
  }

  service {'mysql':
    ensure     => running,
    name       => $servicename,
    enable     => true,
    hasrestart => true,
    subscribe  => File['my.cnf']
  }

  file {'my.cnf':
    ensure => file,
    path   => "/etc/${fs_name}",
    mode   => '0644',
    source => "puppet:///modules/mysql/${config}",
  }

  exec {'root_pass':
    unless  => "mysql -u root -p'${root_pass}' -e 'SHOW DATABASES'",
    command => "mysqladmin -u root password '${root_pass}'",
    require => Service['mysql']
  }
}
