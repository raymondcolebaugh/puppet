class virtualbox {
  case $::operatingsystem {
    redhat, centos: {
      $addkey_cmd = 'rpm --import'
    }
    debian, ubuntu: {
      $addkey_cmd = 'apt-key add'
    }
    default: { fail('Unrecognized operating system.') }
  }
  $repokey_url = 'https://www.virtualbox.org/download/oracle_vbox.asc'

  package {'dkms':
    ensure => latest,
  }

  exec {'enable-repo':
    command => "wget -q ${repokey_url} -O- | sudo ${addkey_cmd} -"
  }

  if $::operatingsystem == debian or $::operatingsystem == ubuntu {
    exec {'apt-get update':
      before => Package['virtualbox'],
    }
  }

  package {'virtualbox':
    ensure  => latest,
    require => Exec['enable-repo'],
  }
}
