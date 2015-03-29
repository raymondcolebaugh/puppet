class rvm {
  $ruby_version = '2.0.0-mri'

  exec {'rvm-key':
    command => 'curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -',
    unless  => 'sudo gpg -k "Michal Papis (RVM signing) <mpapis@gmail.com>"',
    logoutput => true,
    before => Group['rvm']
  }

  exec {'rvm':
    command => "curl -sSL https://get.rvm.io/ | sudo bash -s stable --ruby=mri-${ruby_version}",
    unless => 'locate rvm',
    timeout => 1800,
    before => Group['rvm']
  }

  exec {"use-ruby-${ruby_version}":
    # Must be executed in subshell to load rvm as a function
    command => "su -c 'source /etc/profile.d/rvm.sh && rvm use --default ${ruby_version}'",
    require => Exec['rvm']
  }

  group {'rvm':
    ensure => 'present',
    require => Exec['rvm']
  }
}
