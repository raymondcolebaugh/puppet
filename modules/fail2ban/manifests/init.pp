class fail2ban {
  case $::operatingsystem {
      debian, ubuntu: {
         $servicename = 'fail2ban'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'fail2ban':
      name => $servicename,
      ensure => 'latest',
      before => Service['fail2ban']
   }

   service {'fail2ban':
      name => $servicename,
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['fail2ban'],
   }
}
