# Install Piwik for web analytics
class piwik(
  $webroot = '/var/www/html',
) {
  $dl_url = 'http://builds.piwik.org/piwik.zip'

  package {'unzip':
    ensure => present,
    before => Exec["wget ${dl_url}"],
  }

  exec {"wget ${dl_url}":
    creates => '/tmp/piwik.zip',
    cwd     => '/tmp',
    unless  => "[ -d ${webroot}/piwik ]"
  }

  exec {'unzip piwik.zip':
    cwd     => '/tmp',
    require => Exec["wget ${dl_url}"],
    unless  => "[ -d ${webroot}/piwik ]"
  }

  exec {"mv piwik ${webroot}":
    cwd     => '/tmp',
    require => Exec['unzip piwik.zip'],
    unless  => "[ -d ${webroot}/piwik ]"
  }

  file {"${webroot}/piwik":
    ensure  => directory,
    recurse => true,
    owner   => 'www-data',
    group   => 'www-data',
    require => Exec["mv piwik ${webroot}"],
  }
}
