# Install PHP APC bytecode cache
class phpapc {
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
    ensure => 'latest',
    name   => $pkg,
  }
}
