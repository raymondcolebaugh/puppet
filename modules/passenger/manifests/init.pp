class passenger {
  $passenger_version = '4.0.56'
  $web_server = 'apache'

  case $web_server {
    'apache': {
      $install_cmd = 'passenger-install-apache2-module'
      $config_path = '/etc/apache2/conf.d'
    }
    'nginx': {
      $install_cmd = 'passenger-install-nginx-module'
      $config_path = '/etc/nginx/conf.d'
    }
    default: { fail('Unsupported web server') }
  }
  $packages = ['libcurl4-openssl-dev', 'libssl-dev', 'zlib1g-dev', 'apache2-threaded-dev',
      'ruby-dev', 'libapr1-dev', 'libaprutil1-dev']

  package {'passenger-requirements':
    name => $packages,
    ensure => 'latest',
    before => Exec['passenger']
  }

  exec {'passenger':
    command => "gem install passenger --version ${passenger_version}",
    require => Package['passenger-requirements'],
    before => Exec['create-passenger.conf']
  }

  exec {'create-passenger.conf':
    command => "${install_cmd} --snippet >> ${config_path}/passenger.conf $",
    creates => "${config_path}/passenger.conf",
  }

  exec {'install-passenger':
    command => $install_cmd,
    require => Exec['create-passenger.conf']
  }
}
