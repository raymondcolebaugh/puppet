# Create an ejabberd user
define ejabberd::user (
  $domain,
  $username = $title,
  $password = $title,
) {
  exec {"ejabberdctl register ${username} \
          ${domain} ${password}":
    require => Service['ejabberd']
    unless   => "ejabberdctl  --auth ${username} ${domain} ${password}",
  }
}
