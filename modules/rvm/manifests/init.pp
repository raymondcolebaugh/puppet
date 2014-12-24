class rvm {
  exec {'rvm-key':
    command => 'curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -',
    before => Group['rvm']
  }

  exec {'rvm':
    unless => 'which rvm && rvm info',
    command => 'curl -sSL https://get.rvm.io/ | sudo bash -s stable --ruby=mri-2.0.0',
    before => Group['rvm']
  }

  group {'rvm':
    ensure => 'present',
    require => Exec['rvm']
  }
}
