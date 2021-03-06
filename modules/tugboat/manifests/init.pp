# Install Tugboat to manage DigitalOcean Droplets
class tugboat (
  $client_key,
  $api_key,
  $user,
  $size = 66,
  $image = 684203,
  $region = 1,
  $private_networking = false,
  $backups_enabled = false
) {
  package {'tugboat':
    ensure   => latest,
    provider => 'gem',
  }

  file {"/home/${user}/.tugboat":
    ensure  => present,
    owner   => $user,
    group   => $user,
    content => template('tugboat/tugboat.erb'),
    require => Package['tugboat'],
  }
}
