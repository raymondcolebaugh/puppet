class vagrant {
  # TODO add i686 install support
  case $::operatingsystem {
    redhat, centos: {
      $filename = "vagrant_1.7.2_x86_64.rpm"
      $install = "rpm -i ${filename}"
    }
    debian, ubuntu: {
      $filename = 'vagrant_1.7.2_x86_64.deb'
      $install = "dpkg -i ${filename}"
    }
    default: { fail('Unrecognized operating system.') }
  }
  $dl = "https://dl.bintray.com/mitchellh/vagrant/${filename}"

  exec {"wget ${dl} && ${install} && rm ${filename}":
    unless  => 'which vagrant',
    require => Class['virtualbox']
  }
}
