class nginx {
   case $operatingsystem {
     #redhat, centos: {
        #$servicename = 'httpdd'
         #$config = 'httpd.conf.el'
         #$os_config = 'conf/httpd.conf'
         #}
      debian, ubuntu: {
         $servicename = 'nginx'
         $config = 'nginx.conf.debian'
         $os_config = 'nginx.conf'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'nginx':
      name => $servicename,
      ensure => 'latest',
   }
   service {$servicename:
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['nginx'],
      subscribe => File['nginx.conf']
   }
   file {'nginx.conf':
      path => "/etc/${servicename}/${os_config}",
      ensure => file,
      mode => 644,
      source => "puppet:///modules/nginx/${config}",
   }
}
