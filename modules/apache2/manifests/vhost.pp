# Create and Apache Virtual Host type
define apache2::vhost(
  $home = '/home',
  $enable_login = true,
) {
  case $::operatingsystem {
    debian: {
      $config = "/etc/apache2/sites-available/${title}"
    }
    ubuntu: {
      $config = "/etc/apache2/sites-available/${title}.conf"
    }
    default: { fail('Unsupported operating system') }
  }
  if $enable_login {
    $shell = '/bin/bash'
  } else {
    $shell = '/bin/false'
  }

  user {$title:
    ensure     => present,
    groups     => ['www-data'],
    home       => "${home}/${title}",
    managehome => true,
    shell      => $shell,
  }

  file {
    ["${home}/${title}/${title}",
    "${home}/${title}/${title}/log",
    "${home}/${title}/${title}/public_html"]:
      ensure  => directory,
      owner   => $title,
      group   => www-data,
      mode    => '0775',
      require => User[$title]
  }
  
  file {$config:
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content =>  template('apache2/vhost')
  }

  exec {"a2ensite ${title}":
    require => File[$config]
  }
}
