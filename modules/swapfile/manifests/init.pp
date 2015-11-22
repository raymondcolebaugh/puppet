# Create a swapfile for low-memory VMs
class swapfile(
  $filename,
  $size = 512,
) {
  exec {"dd if=/dev/zero bs=1M count=${size} of=${filename}":
    creates => $filename,
    before  => File[$filename],
  }

  file {$filename:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  exec {'swapfile-fstab':
    command => "echo '${filename}       none swap sw 0 0' >> /etc/fstab",
    unless  => "grep ${filename} /etc/fstab",
    require => File[$filename],
  }

  exec {"mkswap ${filename} && swapon ${filename}":
    require => Exec['swapfile-fstab'],
    unless  => "swapon --show | grep ${filename}",
  }
}
