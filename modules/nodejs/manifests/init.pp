# Install Node.js
class nodejs {
  $setup_url = 'https://deb.nodesource.com/setup_0.12'

  exec {'install-nodejs-repo':
    command => "curl -sL ${setup_url} | sudo bash -",
    creates => '/etc/apt/sources.list.d/nodesource.list',
    require => Package['curl'],
  }

  exec {'node-aptrefresh':
    command => 'apt-get update',
    require => Exec['install-nodejs-repo'],
  }

  package {'nodejs':
    ensure  => latest,
    require => Exec['node-aptrefresh'],
  }
}
