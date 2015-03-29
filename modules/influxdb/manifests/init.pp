class influxdb {
  case $::operatingsystem {
      redhat, centos: {
         $filename = "influxdb-latest-1.${::architecture}.rpm"
         $dl = "http://s3.amazonaws.com/influxdb/${filename}"
         $install_cmd = "rpm -ivh ${filaname}"
      }
      debian, ubuntu: {
         $filename = "influxdb_latest_${::architecture}.deb"
         $dl = "http://s3.amazonaws.com/influxdb/${filename}"
         $install_cmd = "dpkg -i ${filename}"
      }
      default: { fail('Unrecognized operating system.') }
  }

  exec {'dl-influxdb':
    command => "wget ${dl} && ${install_cmd} && rm ${filename}",
    unless  => 'which influxdb'
  }

  service {'influxdb':
    enable  => true,
    ensure  => running,
    require => Exec['dl-influxdb']
  }
}
