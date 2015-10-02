# Create and Apache Virtual Host type
define apache2::vhost(
  $home = '/home',
  $user = $title,
  $enable_login = true,
  $hostname = $title,
  $log_level = 'warn',
  $log_format = 'combined',
  $allow_override = 'none',
  $allow_from = 'all'
) {
  $config = "/etc/apache2/sites-available/${title}.conf"
  if $enable_login {
    $shell = '/bin/bash'
  } else {
    $shell = '/bin/false'
  }

  user {$user:
    ensure     => present,
    groups     => ['www-data'],
    home       => "${home}/${user}",
    managehome => true,
    shell      => $shell,
  }

  file {
    ["${home}/${user}/${title}",
    "${home}/${user}/${title}/log",
    "${home}/${user}/${title}/public_html"]:
      ensure  => directory,
      owner   => $user,
      group   => www-data,
      mode    => '0775',
      require => User[$user],
      before  => Exec["a2ensite ${title}"],
  }
  
  file {$config:
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content =>  template('apache2/vhost.erb'),
    require => Class['apache2'],
    before  => Exec["a2ensite ${title}"],
  }

  exec {"a2ensite ${title}":
    require => File[$config],
    unless  => "[ -f `echo ${config} | sed 's/available/enabled/'` ]",
  }
}
