# HHVM #
## Description ##
Facebook's HHVM interpreter for Hack and PHP.

## Usage ##
```ruby
class {'hhvm':
  log_level => 'Warning',
  log_file  => '/var/log/hhvm/error.log',
  port      => 9000,
}
```
