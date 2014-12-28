class php-apc {
  case $::operatingsystem {
      ubuntu: {
         $pkg = 'php5-apcu'
      }
      debian: {
         $pkg = 'php-apc'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'php-apc':
      name => $pkg,
      ensure => 'latest',
   }
}
