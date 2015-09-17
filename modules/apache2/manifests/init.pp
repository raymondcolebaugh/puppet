# Install Apache web server
class apache2 {
  case $::operatingsystem {
    redhat, centos: {
      $servicename = 'httpd'
      $config = 'httpd.conf.el'
      $os_config = 'conf/httpd.conf'
    }
    debian, ubuntu: {
      $servicename = 'apache2'
      if $::lsbdistcodename == 'wheezy' {
        $config = 'apache2.conf.debian7'
      } else {
        $config = 'apache2.conf.debian8'
      }
      $os_config = 'apache2.conf'
    }
    default: { fail('Unrecognized operating system.') }
  }

  package {'apache2':
    ensure => latest,
    name   => $servicename,
    before => File['apache2.conf']
  }

  service {'apache2':
    ensure    => running,
    name      => $servicename,
    enable    => true,
    require   => Package['apache2'],
    subscribe => File['apache2.conf']
  }

  file {'apache2.conf':
    ensure => file,
    path   => "/etc/${servicename}/${os_config}",
    mode   => '0644',
    owner  => root,
    group  => root,
    source => "puppet:///modules/apache2/${config}",
  }

  if ($::operatingsystem == 'ubuntu' or $::operatingsystem == 'debian') {
    exec {'remove-default-vhost':
      command => 'a2dissite *default',
      unless  => '[ ! -f /etc/apache2/sites-enabled/*default ]',
      require => Package['apache2'],
      notify  => Service['apache2']
    }
  }
}
