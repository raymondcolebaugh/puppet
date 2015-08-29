# Redis #
## Description ##
Redis key-value database

## Usage ##
Add the following to your manifest:
```ruby
class {'redis':
  appendonly       => 'no',
  bind             => '127.0.0.1',
  maxclients       => 10000,
  keepalive        => 0,
  loglevel         => 'notice',
  password         => false,
  master_address   => false,
  masterauth       => false,
  maxmemory_policy => 'volotile-lru',
}
```
