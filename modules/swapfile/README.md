# swapfile #
## Description ##
Create a file to be used as swap space. Recommended for low
memory environments.

## Usage ##
Add the following to your manifest, specifying the size in MB.
```ruby
class {'swapfile':
  filename => '/swapfile',
  size     => 1024,
}
```
