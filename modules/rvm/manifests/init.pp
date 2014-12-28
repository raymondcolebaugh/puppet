class rvm {
  exec {'rvm-key':
    command => 'curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -',
    unless  => 'sudo gpg -k "Michal Papis (RVM signing) <mpapis@gmail.com>"',
    before => Group['rvm']
  }

  exec {'rvm':
    command => 'curl -sSL https://get.rvm.io/ | sudo bash -s stable --ruby=mri-2.0.0',
    unless => 'whereis rvm',
    before => Group['rvm']
  }

  group {'rvm':
    ensure => 'present',
    require => Exec['rvm']
  }
}
