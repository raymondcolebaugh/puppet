# Apache2 #
## Description ##
The classic Apache web server.

From apache2(8):

apache2 is the Apache HyperText Transfer Protocol (HTTP) server program. It is designed to be run as a standalone daemon process. When used
like this it will create a pool of child processes or threads to handle requests.

## Usage ##
Add the following to your manifest:
```ruby
include 'apache'

# Define virtual hosts
apache2::vhost {'example.com':}

# Define a Ruby on Rails application
apache2::railsapp {'example.com':}

# Enable mod_security
include 'apache::mod_security'

# Enable mod_evasive
include 'apache::mod_evasive'
```
