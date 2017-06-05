# Jenkins CI
class jenkins(
  $port = 8080,
  $memory = '256m',
  $preferIPv4 = false,
) {
  case $::operatingsystem {
    debian: {
    }
    ubuntu: {
    }
    default: { fail('Upsuported operating system') }
  }

  $fingerprint = '150F DE3F 7787 E7D1 1EF4  E12A 9B7D 32F2 D505 82E6'

  exec {'jenkins-apt-key':
    command => 'wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -',
    user    => 'root',
    unless  => "apt-key adv --fingerprint | grep '${fingerprint}'",
  }
  
  file {'/etc/apt/sources.list.d/jenkins.list':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'deb http://pkg.jenkins.io/debian-stable binary/',
    notify  => Exec['jenkins-apt-update'],
  }

  exec {'jenkins-apt-update':
    command     => 'apt update',
    require     => Exec['jenkins-apt-key'],
    before      => Package['jenkins'],
    refreshonly => true,
  }
  
  package {'jenkins':
    ensure  => present,
  }

  file {'/etc/default/jenkins':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('jenkins/jenkins_default.erb'),
    require => Package['jenkins']
  }
  
  service {'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}
