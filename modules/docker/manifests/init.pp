# Install Docker for managing Linux containers
class docker {
  package { 'wget': ensure => installed }

  exec {'wget -qO- https://get.docker.com/ | sh':
    unless    => 'which docker',
    logoutput => true,
    require   => Package['wget'],
    timeout   => 1200,
  }
}
