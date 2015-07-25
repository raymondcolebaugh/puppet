# Create and Apache Virtual Host type
define apache2::vhost {
  user {$title:
    ensure     => present,
    groups     => ['www-data'],
    home       => "/home/${title}",
    managehome => true,
    shell      => '/bin/bash',
  }

  file {"/home/${title}/${title}":
      ensure  => directory,
      owner   => $title,
      group   => $title,
      mode    => '0775',
      require => User[$title]
  }

  file {
    ["/home/${title}/${title}/log",
    "/home/${title}/${title}/public_html"]:
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
    content =>  template('apache2/vhost')
  }

  exec {"activate-${title}.vhost":
    command => "a2ensite ${title}",
    require => File["${title}.vhost"]
  }
}
