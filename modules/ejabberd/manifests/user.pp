# Create an ejabberd user
define ejabberd::user (
  $domain,
  $username = $title,
  $password = $title,
) {
  exec {"ejabberdctl register ${username} \
          ${domain} ${password}":
    require => Service['ejabberd'],
    unless  => "ejabberdctl registered_users ${domain} | grep ${username}",
  }
}
