class memcached (
  $host = '127.0.0.1',
  $port = 11211,
  $mem_cap = 64
) {
  case $::operatingsystem {
      ubuntu: {
         $config = 'memcached.ubuntu.conf'
         $user = 'memcache'
      }
      debian: {
         $config = 'memcached.debian.conf'
         $user = 'nobody'
      }
      default: { fail('Unrecognized operating system.') }
   }

   package {'memcached':
      ensure => 'latest',
      before => File['memcached.conf']
   }

   service {'memcached':
      ensure => running,
      enable => true,
      hasrestart => true,
      require => Package['memcached'],
      subscribe => File['memcached.conf']
   }

   file {'memcached.conf':
      path => "/etc/memcached.conf",
      ensure => file,
      mode => '0644',
      owner => root,
      group => root,
      content => template("memcached/memcached.conf.erb"),
   }
}
