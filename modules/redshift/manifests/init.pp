class redshift (
  $lat = 48.1,
  $lon = 11.6,
  $screen = 0,
) {
  package {'redshift':
    ensure => latest,
  }

  file {'/etc/redshift.conf':
    ensure  => present,
    content => template('redshift/redshift.conf.erb'),
    require => Package['redshift']
  }
}
