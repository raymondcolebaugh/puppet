# Add an Apache proxy
define apache2::proxy (
  $pass,
  $domain = $title,
  $https = false,
  $websockets = false,
  $uri = '/websocket',
) {
  class {'apache2::mod_proxy':
    websockets => $websockets,
  }

  file {"/etc/apache2/sites-available/${domain}.conf":
    ensure  => present,
    content => template ('apache2/proxy.erb'),
    notify  => Service[$apache2::servicename],
    require => Package['apache2'],
  }

  exec {"a2ensite ${domain}.conf":
    require => File["/etc/apache2/sites-available/${domain}.conf"],
    unless  => "[ -f /etc/apache2/sites-enabled/${domain}.conf ]",
  }
}
