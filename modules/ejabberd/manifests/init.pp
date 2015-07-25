# Install ejabberd xmpp server
class ejabberd(
  $domain,
  $admin_pass,
  $admin_user = 'admin',
  $cert = '/etc/ejabberd/ejabberd.pem',
  $users = []
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
  }

  service {'ejabberd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    require    => File['/etc/ejabberd/ejabberd.cfg'],
  }

  ejabberd::user {$admin_user:
    password => $admin_pass,
    domain   => $domain,
    require  => Service['ejabberd']
  }
}
