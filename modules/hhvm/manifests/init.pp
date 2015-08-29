# Install HHVM interpreter
class hhvm(
  $log_level = 'Warning',
  $log_file = '/var/log/hhvm/error.log',
  $port = 9000,
) {
  $fingerprint = '5A16E7281BE7A449'
  $keyserver = 'hkp://keyserver.ubuntu.com:80'
  $recvkeys = "--recv-keys --keyserver ${keyserver}  0x${fingerprint}"
  $listkeys = '--list-public-keys --fingerprint --with-colons'

  case $::operatingsystem {
    debian: {
      $repo_string = 'debian jessie'
    }
    ubuntu: {
      $repo_string = 'ubuntu trusty'
    }
    default: {fail('Unrecognized operating system')}
  }

  exec {"apt-key adv ${recvkeys}":
    before => Package['hhvm'],
    unless => "apt-key adv ${listkeys} | grep ${fingerprint}",
  }

  file {'/etc/apt/sources.list.d/hhvm.list':
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content => "deb http://dl.hhvm.com/${repo_string} main",
    before  => Exec['hhvm-update-cache']
  }

  exec {'hhvm-update-cache':
    command => 'apt-get update',
    require => Exec["apt-key adv ${recvkeys}"]
  }

  package {'hhvm':
    ensure  => latest,
    require => Exec['hhvm-update-cache'],
  }

  service {'hhvm':
    ensure => running,
    enable => true,
  }

  file {'/etc/hhvm/php.ini':
    notify  => Service['hhvm'],
    content => template('hhvm/php.ini.erb'),
  }

  file {'/etc/hhvm/server.ini':
    notify  => Service['hhvm'],
    content => template('hhvm/server.ini.erb'),
  }
}
