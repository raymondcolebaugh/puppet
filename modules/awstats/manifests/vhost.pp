# Monitor a virtual host with AWstats
define awstats::vhost(
  $log_path = "/var/log/apache2/${title}_access_log",
  $log_format = 1,
  $interval = 30,
  $user = 'www-data'
) {
  file {"/etc/awstats/awstats.${title}.conf":
    ensure  => present,
    content => template('awstats/vhost.conf.erb'),
    require => Package['awstats']
  }

  cron {"awstats.${title}":
    user    => 'www-data',
    minute  => "*/${interval}",
    command => "/usr/lib/cgi-bin/awstats.pl -config=${title} -update",
    require => File["/etc/awstats/awstats.${title}.conf"]
  }

  file {"/var/lib/awstats/${title}":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => Package['awstats']
  }

  file {$log_path:
    ensure => present,
    owner  => 'root',
    group  => $user,
  }
}

