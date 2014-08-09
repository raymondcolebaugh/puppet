class apache2 {
   case $operatingsystem {
      redhat, centos: {
         $servicename = 'httpd'
         $config = 'httpd.conf.el'
         $os_config = 'conf/httpd.conf'
      }
      debian, ubuntu: {
         $servicename = 'apache2'
         $config = 'apache2.conf.debian'
         $os_config = 'apache2.conf'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'apache2':
      name => $servicename,
      ensure => 'latest',
   }
   service {$servicename:
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['apache2'],
      subscribe => File['apache2.conf']
   }
   file {'apache2.conf':
      path => "/etc/${servicename}/${os_config}",
      ensure => file,
      mode => 644,
      owner => root,
      group => root,
      source => "puppet:///modules/apache2/${config}",
   }
}
