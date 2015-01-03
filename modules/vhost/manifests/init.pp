define vhost (
  $passwd = $title,
  $db = $title,
  $mysql_rootpw = 'root',
  $server_name = "${title}.local"
) {
  user {$title:
    ensure => present,
    groups => ['www-data'],
    home => "/home/${title}",
    managehome => true,
    shell => '/bin/bash',
  }

  file {
    ["/home/${title}",
     "/home/${title}/${title}",
     "/home/${title}/${title}/log",
     "/home/${title}/${title}/public_html"]:
      ensure => directory,
      owner => $title,
      group => www-data,
      mode => '775',
      require => User[$title]
  }
  
#  $install_path = "/home/${title}/${title}"
#  $repo_url = "https://github.com/x2engine/x2engine.git"
#  exec {"${title}-repo":
#    creates => $install_path,
#    path => '/usr/bin/',
#    command => 'git clone ${repo_url} ${install_path}',
#    require => Exec["${title}-db"]
#  }

  exec {"${title}-db":
    unless => "mysql -u ${title} -p${passwd} ${db}",
    command => "mysql -u root -p${mysql_rootpw} -e '
        CREATE USER ${title}@localhost
          IDENTIFIED BY \"${passwd}\";
        CREATE DATABASE ${db};
        GRANT ALL ON ${db}.* TO ${title}@localhost;
        FLUSH PRIVILEGES;
      '",
    require => User[$title]
  }

  file {"${title}.vhost":
    path => "/etc/apache2/sites-available/${title}",
    ensure => file,
    mode => '0644',
    owner => root,
    group => root,
    content =>  template('apache2/vhost')
  }

  exec {"activate-${title}.vhost":
    command => "a2ensite ${title}",
    require => File["${title}.vhost"]
  }
}
