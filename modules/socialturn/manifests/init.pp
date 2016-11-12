# SocialTurn social automation
class socialturn(
  $pass,
  $fb_appid,
  $fb_appsecret,
  $twitter_apikey,
  $twitter_apisecret,
  $twitter_username = false,
  $twitter_token = false,
  $twitter_secret = false,
  $user = 'socialturn',
  $dbname = 'socialturn',
  $dbhost = 'localhost',
  $domain = 'localhost',
  $port = false,
  $suggestion_lists = ['design','technology','lifehacks'],
  $server_salt = 'CHANGEME',
) {
  if $port {
    $host_string = "${domain}:${port}"
  } else {
    $host_string = $domain
  }

  git::repo {'socialturn':
    url     => 'https://github.com/anantgarg/socialturn',
    target  => 'public_html',
    user    => $user,
    cwd     => "/home/${user}/${domain}",
    require => Apache2::Vhost[$domain],
  }

  exec {'socialturn-sql':
    command => "cat db/*.txt | sed 's/^$/;/g' | \
                  mysql -u ${user} -p'${pass}' ${dbname}",
    user    => $user,
    cwd     => "/home/${user}/${domain}/public_html",
    unless  => "mysql -u ${user} -p'${pass}' ${dbname} \
                  -e 'show tables' | grep users_accounts ",
    require => Git::Repo['socialturn'],
  }


  file {"/home/${user}/${domain}/public_html/config.php":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('socialturn/config.php.erb'),
    require => Git::Repo['socialturn'],
  }


  cron {'socialturn-suggestions':
    command => "curl ${domain}/cron/suggestions",
    user    => $user,
    hour    => 6,
    minute  => 15,
    require => Apache2::Vhost[$domain],
  }

  cron {'socialturn-posts':
    command => "curl ${domain}/cron/posts",
    user    => $user,
    minute  => '*/5',
    require => Apache2::Vhost[$domain],
  }
}
