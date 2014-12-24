class squid {
  case $::operatingsystem {
      debian, ubuntu: {
         $servicename = 'squid'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'squid':
      name   => $servicename,
      ensure => 'latest',
      before => Service['squid']
   }

   service {'squid':
      name       => $servicename,
      ensure     => running,
      enable     => true,
      hasrestart => true,
      require    => Package['squid'],
   }

   file {'squid.conf':
      path   => '/etc/squid/squid.conf',
      mode   => '0640',
      notify => Service['squid']
   }
}
