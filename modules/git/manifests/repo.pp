# Fetch a git repo
define git::repo(
  $url,
  $target = $title,
  $user = $title,
  $cwd = '/tmp',
  $gittag = false,
) {
  include 'git'

  exec {"clone-${title}":
    command => "git clone ${url} ${target}",
    user    => $user,
    cwd     => $cwd,
    require => Package['git'],
    unless  => "[ -d ${cwd}/${target}/.git ]",
  }

  if $gittag {
    exec {"checkout-${title}-${gittag}":
      command     => "git checkout ${gittag}",
      user        => $user,
      cwd         => $cwd,
      require     => Exec["clone-${title}"],
      refreshonly => true,
    }
  }
}
