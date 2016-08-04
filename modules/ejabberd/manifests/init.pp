# Install ejabberd xmpp server
class ejabberd(
  $admin_user = 'admin',
  $admin_pass = 'admin',
  $cert = '/etc/ejabberd/ejabberd.pem',
  $domain = $::fqdn,
) {
  package {'ejabberd':
    ensure => latest,
  }

  file {'/etc/ejabberd/ejabberd.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'ejabberd',
    mode    => '0640',
    content => template ('ejabberd/ejabberd.cfg.erb'),
    require => Package['ejabberd'],
    notify  => Service['ejabberd'],
  }

  service {'ejabberd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['/etc/ejabberd/ejabberd.cfg'],
  }

  ejabberd::user {$admin_user:
    domain   => 'localhost',
    password => $admin_pass,
  }
}
