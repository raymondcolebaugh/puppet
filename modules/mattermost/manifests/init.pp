# Install Mattermost for Chat
class mattermost(
  $mysql_root,
  $db_pass = 'mattermost',
  $db_host = 'localhost',
) {
  $version = '3.2.0'
  $source_url = "https://releases.mattermost.com/${version}/mattermost-team-${version}-linux-amd64.tar.gz"

  exec {'download-mattermost':
    command => "curl -sSL ${source_url} | tar -zxf -",
    cwd     => '/opt',
    creates => '/opt/mattermost/bin/platform',
    before  => Service['mattermost'],
  }

  user {'mattermost':
    ensure     => present,
    name       => 'mattermost',
    comment    => 'Mattermost Chat',
    home       => '/opt/mattermost',
    managehome => true,
    shell      => '/bin/bash',
    before     => Service['mattermost'],
  }

  mysql::database {'mattermost':
    mysql_root => $mysql_root,
    pass       => $db_pass,
    before     => Service['mattermost'],
  }

  file {'/etc/systemd/system/mattermost.service':
    ensure => present,
    source => 'puppet:///modules/mattermost/systemd.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    before => Service['mattermost'],
  }

  file {'/opt/mattermost/config/config.json':
    ensure  => present,
    content => template('mattermost/config.json.erb'),
    owner   => 'mattermost',
    group   => 'mattermost',
    mode    => '0660',
    notify  => Service['mattermost'],
  }

  file {'/opt/mattermost/data':
    ensure => directory,
    owner  => 'mattermost',
    group  => 'mattermost',
    mode   => '0660',
    notify => Service['mattermost'],
  }

  exec {'chown -R mattermost:mattermost /opt/mattermost':
    before  => Service['mattermost'],
    require => [User['mattermost'], Exec['download-mattermost']],
  }

  service {'mattermost':
    ensure     => running,
    name       => 'mattermost',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
