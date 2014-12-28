class composer {
  exec {'composer':
    command => 'curl -sS https://getcomposer.org/installer | php',
    unless  => 'which composer'
  }

  exec {'system-wide-composer':
    command => 'mv composer.phar /usr/local/bin/composer',
    unless  => 'ls /usr/local/bin/composer',
    require => Exec['composer']
  }
}
