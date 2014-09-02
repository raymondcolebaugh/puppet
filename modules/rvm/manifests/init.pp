class rvm {
  exec {'rvm':
    unless => 'which rvm && rvm info',
    command => 'curl -sSL https://get.rvm.io/ | bash -s stable'
  }

  group {'rvm':
    ensure => 'present'
  }
}
