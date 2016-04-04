# Install Redis key-value database
class redis(
  $appendonly = 'no',
  $bind = '127.0.0.1',
  $port = 6379,
  $maxclients = 10000,
  $keepalive = 0,
  $log_level = 'notice',
  $password = false,
  $master_address = false,
  $masterauth = false,
  $maxmemory_policy = 'volatile-lru',
  $use_sockets = false,
) {
  package {'redis-server':
    ensure => latest,
  }

  file {'/etc/redis/redis.conf':
    ensure  => present,
    owner   => 'redis',
    group   => 'redis',
    mode    => '0660',
    content => template('redis/redis.conf.erb'),
    notify  => Service['redis-server'],
  }

  service {'redis-server':
    ensure => running,
    enable => true,
  }
}
