class haveged {
   package {'haveged':
      ensure => 'latest',
   }

   service {'haveged':
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['haveged'],
   }
}
