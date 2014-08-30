class ntp {
   case $operatingsystem {
      redhat, centos: {
         $servicename = 'ntpd'
         $config = 'ntp.conf.el'
      }
      debian, ubuntu: {
         $servicename = 'ntp'
         $config = 'ntp.conf.debian'
      }
      default: { fail('Unrecognized operating system.') }
   }

   if str2bool("$is_virtual") {
      package {'ntp':
         name => 'ntp',
         ensure => absent,
      }
      service {$servicename:
         name => $servicename,
         ensure => stopped,
         enable => false,
      }
   } else {
      package {'ntp':
         name => 'ntp',
         ensure => 'latest',
      }
      service {$servicename:
         name => $servicename,
         ensure => running,
         enable => true,
         hasrestart => true,
         require => Package['ntp'],
         subscribe => File['ntp.conf']
      }
      file {'ntp.conf':
         path => '/etc/ntp.conf',
         ensure => file,
         mode => '0644',
         source => 'puppet:///modules/ntp/${config}',
      }
   }
}
