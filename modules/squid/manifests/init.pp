# Install Squid caching proxy
class squid(
  $http_allow = 'localhost',
  $localnet = false,
  $transparent = false,
  $allow_manager = 'localhost',
  $cache_mem = 128,
  $memory_replacement = 'lru',
  $cache_replacement = 'lru',
  $fs_type = 'ufs',
  $cache_dir = '/var/spool/squid',
  $cache_size = 100,
  $cache_l1 = 16,
  $cache_l2 = 256,
  $peer_hostname = false,
  $peer_type = 'parent',
  $peer_proxy_port = 3128,
  $peer_icp_port = 3130,
  $peer_options = 'proxy-only',
) {
  case $::operatingsystem {
    debian, ubuntu: {
      if $::distcodename == 'wheezy' or
        $::distcodename == 'precise' {
        $servicename = 'squid'
      } else {
        $servicename = 'squid3'
      }
    }
    default: { fail('Unrecognized operating system.') }
  }

  package {'squid':
    ensure => 'latest',
    name   => $servicename,
    before => Service['squid']
  }

  user {'squid':
    ensure => present,
    before => File['/var/spool/squid'],
  }

  file {'/var/spool/squid':
    ensure => directory,
    mode   => '0770',
    owner  => 'squid',
    group  => 'squid',
    before => Exec['squid-zero-cache'],
  }

  exec {'squid-zero-cache':
    command     => "${servicename} -z ${cache_dir}",
    refreshonly => true,
    require     => Package['squid'],
  }

  service {'squid':
    ensure     => running,
    name       => $servicename,
    enable     => true,
    hasrestart => true,
    require    => Package['squid'],
  }

  file {'squid.conf':
    path    => "/etc/${servicename}/squid.conf",
    mode    => '0640',
    notify  => Service['squid'],
    content => template("squid/${servicename}.conf.erb"),
    require => Package['squid'],
    before  => Exec['squid-zero-cache'],
  }
}
