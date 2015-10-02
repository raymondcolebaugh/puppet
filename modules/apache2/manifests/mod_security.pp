# Install mod_security
class apache2::mod_security {
  case $::operatingsystem {
    redhat, centos: {
      $package = 'mod_security'
      $dest    = '/etc/httpd/modsecurity.d/'
    }
    debian, ubuntu: {
      $package = 'libapache2-modsecurity'
      $dest    = '/etc/modsecurity/'
    }
    default: { fail('Unrecognized operating system.') }
  }

  package {'modsecurity':
    ensure => 'latest',
    name   => $package,
  }

  exec {'download-crs':
    command => 'wget -O crs.tar.gz https://github.com/SpiderLabs/owasp-modsecurity-crs/tarball/master',
    require => Package['modsecurity'],
    cwd     => '/tmp',
    unless  => "[ -d ${dest} ]",
  }

  exec {'extract-crs':
    command     => 'tar xf crs.tar.gz',
    require     => Exec['download-crs'],
    refreshonly => true,
    cwd         => '/tmp'
  }

  exec {'copy-crs':
    command     => "mv SpiderLabs-owasp-modsecurity-crs-*/ ${dest}",
    require     => Exec['extract-crs'],
    refreshonly => true,
    cwd         => '/tmp'
  }

  Exec['download-crs']
    ~> Exec['extract-crs']
    ~> Exec['copy-crs']
}
