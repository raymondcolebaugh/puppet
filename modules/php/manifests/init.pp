class php {
   case $operatingsystem {
      redhat, centos: {
         $servicename = 'mysqld'
         $pkgs = ['php', 'php-cli', 'php-gd', 'php-mysql', 'php-mcrypt']
      }
      debian, ubuntu: {
         $servicename = 'mysql'
         $pkgs = ['php5', 'php5-cli', 'php5-gd', 'php5-mysql', 'php-mcrypt']
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'php':
      name => $pkgs,
      ensure => 'latest',
   }
   service {$servicename:
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['php'],
   }
}
