# Tugboat #
## Description ##
Tugboat is a command line client written in Ruby used for managing
your digital Ocean droplets.

Please see https://github.com/pearkes/tugboat for more information. 

## Usage ##
Add the following to your manifest and set your client and API keys:
```ruby
class {'tugboat':
  user               => 'username',
  client_key         => 'CLIENT_KEY',
  api_key            => 'API_KEY',
  size               => 66,
  image              => 684203,
  region             => 1,
  private_networking => false,
  backups_enabled    => false
}
```
