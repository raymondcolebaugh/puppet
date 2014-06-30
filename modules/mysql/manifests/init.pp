class mysql {
   case $operatingsystem {
      redhat, centos: {
         $servicename = 'mysqld'
         $pkgname = 'mysql-server'
         $config = 'my.conf.el'
         $os_config = 'my.conf'
      }
      debian, ubuntu: {
         $servicename = 'mysql'
         $pkgname = 'mysql-server-5.5'
         $config = 'my.conf.debian'
         $os_config = 'mysql/my.conf'
      }
      default: { fail("Unrecognized operating system.") }
   }

   package {'mysql':
      name => $pkgname,
      ensure => 'latest',
   }
   service {$servicename
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['mysql'],
      subscribe => File['my.cnf']
   }
   file {'my.conf':
      path => '/etc/${os_config}',
      ensure => file,
      mode => 644,
      source => 'puppet:///modules/mysql/${config}',
   }
}
