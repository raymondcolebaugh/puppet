# Install Mumble server (murmur) for voice chat
class mumble(
  $welcome_txt = '<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />',
  $server_password = false,
  $users = 100,
  $bandwidth = 72000,
) {
  package {'mumble-server':
    ensure => present,
  }

  file {'/etc/mumble-server.ini':
    ensure  => present,
    content => template('mumble/mumble-server.ini.erb'),
    owner   => 'mumble-server',
    group   => 'mumble-server',
    mode    => '0660',
    notify  => Service['mumble-server'],
    require => Package['mumble-server'],
  }

  service {'mumble-server':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
