# Enable a ufw service
define ufw::service($port = $title) {
  exec {"ufw allow ${port}":
    unless  => "ufw status | grep '^${port} '",
  }
}
