class passenger {
  $config_path = '/etc/apache2/conf.d'
  $config_src = 'passenger.apache.conf'

  $web_server = 'apache'
  case $web_server {
    'apache': {
      $install_cmd = 'passenger-install-apache2-module'
    }
    'nginx': {
      $install_cmd = 'passenger-install-nginx-module'
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
    command => 'gem install passenger --version 4.0.56',
    require => Package['passenger-requirements'],
    before => File['passenger.conf']
  }

  file {'passenger.conf':
    path => "${config_path}/passenger.conf",
    mode => '0640',
    source => "puppet:///modules/passenger/${config_src}"
  }

  exec {'install-passenger':
    command => $install_cmd,
    require => File['passenger.conf']
  }
}
