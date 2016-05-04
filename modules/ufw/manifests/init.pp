# Install ufw Firewall
class ufw(
  $default_incoming = 'reject',
  $default_outgoing = 'allow',
  $ports = [22],
) {
  package {'ufw':
    ensure  => present,
  }
  
  exec {'ufw-default-incoming':
    command => "ufw default ${default_incoming} incoming",
    require => Package['ufw'],
    unless  => "ufw status verbose | grep 'Default:.*${default_ingoing} (incoming)'",
  }
  
  exec {'ufw-default-outgoing':
    command => "ufw default ${default_outgoing} outgoing",
    require => Package['ufw'],
    unless  => "ufw status verbose | grep 'Default:.*${default_outgoing} (outgoing)'",
  }

  ufw::service{$ports:
    require => [Exec['ufw-default-incoming'],Exec['ufw-default-incoming']],
  }

  exec {'ufw --force enable':
    require => Ufw::Service[$ports],
    unless  => 'ufw status | grep "Status: active"',
  }
}
