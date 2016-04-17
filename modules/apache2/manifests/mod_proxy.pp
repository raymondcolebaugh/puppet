# Enable Apache2 proxy module
class apache2::mod_proxy(
  $websockets = false,
) {
  exec {'a2enmod proxy':
    require => Package['apache2'],
    unless  => '[ -f /etc/apache2/mods-enabled/proxy.load ]',
  }

  exec {'a2enmod proxy_http':
    require => Package['apache2'],
    unless  => '[ -f /etc/apache2/mods-enabled/proxy_http.load ]',
  }

  exec {'a2enmod rewrite':
    require => Package['apache2'],
    unless  => '[ -f /etc/apache2/mods-enabled/rewrite.load ]',
  }

  if $websockets {
    exec {'a2enmod proxy_wstunnel':
      require => Package['apache2'],
      unless  => '[ -f /etc/apache2/mods-enabled/proxy_wstunnel.load ]',
    }
  }
}
