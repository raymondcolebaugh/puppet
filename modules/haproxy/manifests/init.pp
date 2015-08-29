# Install HAProxy load balancer
class haproxy {
  if $::operatingsystem == 'debian' {
    $use_ppa = false
    if $::lsbmajdistrelease > 7 {
      $install_options = []
      $enable_backports = false
    } elsif $::lsbmajdistrelease == 7 {
      $install_options = [{'t' => 'wheezy_backports'}]
      $enable_backports = true
    } else {
      fail('Unsupported Debian version.')
    }
  } elsif $::operatingsystem == 'ubuntu' {
    $enable_backports = false
    $use_ppa = true
    $install_options = []
  } elsif $::operatingsystem in [ 'CentOS', 'RedHat' ]  {
    $enable_backports = false
    $use_ppa = false
    $install_options = []
  } else {
    fail('Unrecognized operating system.')
  }

  if $enable_backports {
    file {'/etc/apt/sources.list.d/backports.list':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => 'deb http://cdn.debian.net/debian wheezy-backports main',
      before  => Package['haproxy']
    }
  }

  if $use_ppa {
    exec {'add-haproxy-ppa':
      command => 'add-apt-repository ppa:vbernat/haproxy-1.5',
      before  => Package['haproxy']
    }
  }

  package {'haproxy':
    ensure          => latest,
    install_options => $install_options
  }

  service {'haproxy':
    enable  => true,
    require => Package['haproxy']
  }

  file {'/etc/haproxy/haproxy.cfg':
    content => template('haproxy/haproxy.cfg'),
    require => Service['haproxy'],
  }
}
