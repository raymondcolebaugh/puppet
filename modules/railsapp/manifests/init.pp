define railsapp (
  $mysql_rootpw = $title,
  $password = $title,
  $database = $title,
) {
  user {$title:
    ensure => present,
    groups => ['www-data'],
    home => "/home/${title}",
    managehome => true,
    shell => '/bin/bash'
  }

  file {
    ["/home/${title}/${title}/",
     "/home/${title}/${title}/log",
     "/home/${title}/${title}/shared",
     "/home/${title}/${title}/public",
     "/home/${title}/${title}/shared/config"]:
    ensure => directory,
    owner => "${title}",
    group => www-data,
    mode => '0775',
    require => User["${title}"]
  }

  exec {"${title}db":
    unless => "mysql -u ${title} -p${password} ${database}",
    command => "mysql -u root -p${rootpw} -e '
      CREATE USER ${title}@localhost
        IDENTIFIED BY \"${password}\";
      CREATE DATABASE ${database} DEFAULT CHARACTER SET utf8;
      GRANT ALL ON ${database}.* to ${title}@localhost;
    '",
    require => User["${title}"]
  }

  file {"${title}.vhost":
    path => "/etc/apache2/sites-available/${title}",
    ensure => file,
    mode => '0644',
    owner => root,
    group => root,
    content => template('railsapp/vhost_rails.erb'),
    require => User[$title]
  }

  exec {"activate-${title}.vhost":
    command => "a2ensite ${title}",
    require => File["${title}.vhost"],
  }
}
