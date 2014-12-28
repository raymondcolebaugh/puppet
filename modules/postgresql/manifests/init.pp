class postgresql {
  case $::operatingsystem {
      ubuntu: {
         $version = '9.3'
         $config = 'postgresql.ubuntu.conf'
      }
      debian: {
         $version = '9.1'
         $config = 'postgresql.debian.conf'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'postgresql':
      name => "postgresql-${version}",
      ensure => 'latest',
      before => File['postgresql.conf']
   }

   service {'postgresql':
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['postgresql'],
      subscribe => File['postgresql.conf']
   }

   file {'postgresql.conf':
      path => "/etc/postgresql/${version}/main/postgresql.conf",
      ensure => file,
      mode => '0644',
      owner => root,
      group => root,
      source => "puppet:///modules/postgresql/${config}",
   }
}
