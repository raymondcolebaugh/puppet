class composer(
  $composer_home = '/opt/composer',
){
  exec {'composer':
    command => "curl -sS https://getcomposer.org/installer | COMPOSER_HOME=${composer_home} php",
    unless  => 'which composer'
  }

  exec {'system-wide-composer':
    command => 'mv composer.phar /usr/local/bin/composer',
    unless  => 'ls /usr/local/bin/composer',
    require => Exec['composer']
  }
}
