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
    cwd     => '/tmp'
  }

  exec {'extract-crs':
    command => 'tar xf crs.tar.gz',
    require => Exec['download-crs'],
    cwd     => '/tmp'
  }

  exec {'copy-crs':
    command => "rm -r ${dest} crs.tar.gz && \
                mv SpiderLabs-owasp-modsecurity-crs-*/ ${dest}",
    require => Exec['extract-crs'],
    cwd     => '/tmp'
  }
}
