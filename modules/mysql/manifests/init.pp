class mysql {
   case $operatingsystem {
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
      default: { fail("Unrecognized operating system.") }
   }

   package {'mysql':
      name => $pkgname,
      ensure => 'latest',
   }
   service {'mysql':
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['mysql'],
      subscribe => File['my.cnf']
   }
   file {'my.cnf':
      path => "/etc/${fs_name}",
      ensure => file,
      mode => 644,
      source => "puppet:///modules/mysql/${config}",
   }
}
