# Create an Apache virtual host for a Ruby on Rails app
define apache2::railsapp(
  $home = '/home',
  $user = $title,
  $enable_login = true,
) {
  case $::operatingsystem {
    debian: {
      $config = "/etc/apache2/sites-available/${title}.conf"
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
    "${home}/${user}/${title}/shared",
    "${home}/${user}/${title}/public",
    "${home}/${user}/${title}/shared/config"]:
      ensure  => directory,
      owner   => $user,
      group   => www-data,
      mode    => '0775',
      require => Class['apache2'],
      before  => Exec["a2ensite ${title}"],
  }

  file {$config:
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('apache2/vhost_rails.erb'),
    require => Class['apache2'],
  }

  exec {"a2ensite ${title}":
    require => File[$config],
    unless  => "[ -f `echo ${config} | sed 's/available/enabled/'` ]",
  }
}
