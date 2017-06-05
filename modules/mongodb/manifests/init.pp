# Install MongoDB object storage
class mongodb(
  $port = 27017,
  $bindIp = '127.0.0.1',
  $authorization = 'enabled',
  $admin_name = 'admin',
  $admin_pass = 'admin',
) {
  case $::operatingsystem {
    debian: {
      $repo = "debian ${::lsbdistcodename}/mongodb-org/3.0 main"
    }
    ubuntu: {
      $repo = "ubuntu ${::lsbdistcodename}/mongodb-org/3.0 multiverse"
    }
    default: { fail('Upsuported operating system') }
  }

  $fingerprint = '492E AFE8 CD01 6A07 919F  1D2B 9ECB EC46 7F0C EB10'

  exec {'mongodb-apt-key':
    command => 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
    user    => 'root',
    unless  => "apt-key adv --fingerprint | grep '${fingerprint}'",
  }
  
  file {'/etc/apt/sources.list.d/mongodb-org-3.0.list':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "deb http://repo.mongodb.org/apt/${repo}",
    before  => Package['mongodb-org'],
  }

  package {'mongodb-org':
    ensure  => present,
  }
  
  file {'/etc/mongod.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mongodb/mongod.conf.erb'),
    require => Package['mongodb-org'],
    notify  => Service['mongod'],
  }
  
  service {'mongod':
    ensure  => running,
    enable  => true,
    require => Package['mongodb-org'],
  }

  $userJs = "db.createUser({user: \"${admin_name}\", pwd: \"${admin_pass}\", roles: [{role: \"userAdminAnyDatabase\", db: \"admin\"}]})"
  exec {"mongo admin --eval '${userJs}'":
    require => Service['mongod'],
    unless  => "mongo -u ${admin_name} -p${admin_pass} admin",
  }
  
}
