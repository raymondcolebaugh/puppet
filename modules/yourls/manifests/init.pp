# YoURLs URL shortener
class yourls(
  $pass,
  $user = 'yourls',
  $domain = 'localhost',
  $dbname = 'yourls',
  $dbhost = 'localhost',
  $unique_urls = true,
  $private = true,
  $port = false,
  $admin_pass = 'admin',
  $cookie_key = 'CHANGEME',
) {
  if $port {
    $host_string = "${domain}:${port}"
  } else {
    $host_string = $domain
  }

  git::repo {'yourls':
    url     => 'https://github.com/YOURLS/YOURLS',
    target  => 'public_html',
    user    => $user,
    cwd     => "/home/${user}/${domain}",
    require => Apache2::Vhost[$domain],
  }

  file {"/home/${user}/${domain}/public_html/user/config.php":
    ensure  => present,
    owner   => $user,
    group   => 'www-data',
    content => template('yourls/config.php.erb'),
    require => Git::Repo['yourls'],
  }
}
