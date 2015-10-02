# Install Passenger Rails application server
class passenger(
  $web_server = 'apache',
  $passenger_version = '5.0.18'
) {
  case $web_server {
    'apache': {
      $install_cmd = 'passenger-install-apache2-module'
      #$config_path = '/etc/apache2/conf.d'
      $config_path = '/etc/apache2/conf-available'
    }
    'nginx': {
      $install_cmd = 'passenger-install-nginx-module'
      $config_path = '/etc/nginx/conf.d'
    }
    default: { fail('Unsupported web server') }
  }
  $requirements = ['libcurl4-openssl-dev', 'libssl-dev', 'zlib1g-dev',
    'apache2-dev', 'ruby-dev', 'libapr1-dev', 'libaprutil1-dev']

  package {$requirements:
    ensure => latest,
    before => Exec['passenger']
  }

  exec {'passenger':
    command => "gem install passenger --version ${passenger_version}",
    require => Package[$requirements],
    before  => Exec['install-passenger'],
    unless  => 'which passenger',
  }

  exec {'install-passenger':
    command => $install_cmd,
    before  => Exec['create-passenger.conf'],
    unless  => "[ -f `grep LoadModule ${config_path}/passenger.conf | cut -d' ' -f3` ]",
  }

  exec {'create-passenger.conf':
    command => "${install_cmd} --snippet > ${config_path}/passenger.conf",
    creates => "${config_path}/passenger.conf",
  }

  if ($web_server == 'apache') {
    $enabled = "echo ${config_path}/passenger.conf | sed 's/available/enabled/'"
    exec {'a2enconf passenger':
      require => Exec['create-passenger.conf'],
      unless  => "[ -f `${enabled}` ]",
    }
  }
}
