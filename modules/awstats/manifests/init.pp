# Install AWstats for monitoring website statistics
class awstats {
  package {'awstats':
    ensure => latest,
  }

  file {'/etc/awstats/awstats.conf':
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/awstats/awstats.conf',
    require => Package['awstats']
  }

  file {'/etc/awstats/awstats.conf.local':
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/awstats/awstats.conf.local',
    require => Package['awstats']
  }

  file {'/etc/apache2/conf-available/awstats.conf':
    ensure  => file,
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('awstats/apache.conf.erb'),
    require => [Package['awstats'], Class['apache2']]
  }

  exec {'a2enconf awstats':
    unless => '[ -f /etc/apache2/conf-enabled/awstats.conf ]',
  }

  exec {'a2enmod cgi':
    unless => '[ -f /etc/apache2/mods-enabled/cgi.load ]',
  }
}
