# Create an Apache virtual host for a Ruby on Rails app
define apache2::railsapp (
  $name = $title
) {
  user {$title:
    ensure     => present,
    groups     => ['www-data'],
    home       => "/home/${title}",
    managehome => true,
    shell      => '/bin/bash'
  }

  file {
    ["/home/${title}/${title}/log",
    "/home/${title}/${title}/shared",
    "/home/${title}/${title}/public",
    "/home/${title}/${title}/shared/config"]:
      ensure  => directory,
      owner   => $title,
      group   => www-data,
      mode    => '0775',
      require => User[$title]
  }

  file {"${title}.vhost":
    ensure  => file,
    path    => "/etc/apache2/sites-available/${title}",
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('railsapp/vhost_rails.erb'),
    require => User[$title]
  }

  exec {"activate-${title}.vhost":
    command => "a2ensite ${title}",
    require => File["${title}.vhost"],
  }
}
