class mod_evasive {
  case $::operatingsystem {
      redhat, centos: {
         $package = 'mod_evasive'
      }
      debian, ubuntu: {
         $package = 'libapache2-mod-evasive'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'mod_evasive':
      name   => $package,
      ensure => 'latest',
   }
}
