class passenger {
  $config_path = '/etc/apache2/conf.d'
  $config_src = 'passenger.apache.conf'
  $install_cmd = 'passenger-install-apache2-module'
  $packages = ['libcurl4-openssl-dev', 'libssl-dev', 'zlib1g-dev', 'apache2-threaded-dev',
      'ruby-dev', 'libapr1-dev', 'libaprutil1-dev']

  package {'depends':
    name => $packages,
    ensure => 'latest',
  }

  package {'passenger':
    name => 'passenger',
    provider => 'gem',
    ensure => '4.0.49',
    require => Package['depends'],
  }

  file {'passenger.conf':
    path => "${config_path}/passenger.conf",
    mode => '0640',
    source => "puppet://modules/passenger/${config_src}"
  }

  exec {'install-passenger':
    command => $install_cmd,
  }

}
