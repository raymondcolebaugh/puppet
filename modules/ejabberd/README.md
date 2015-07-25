# ejabberd #
## Desciption ##
From ejabberd(8):

ejabberd is a distributed fault-tolerant Jabber/XMPP server written in Erlang.

Its main features are:
* XMPP-compliant
* Distributed: ejabberd can run on a cluster of machines
* Fault-tolerant: All the information can be stored on more than one node, nodes can be added or replaced `on the fly'
* Built-in Multi-User Chat service
* Built-in IRC transport
* Built-in Publish-Subscribe service
* Built-in Jabber User Directory service based on users vCards
* SSL support
* Support for internationalized user messages

## Usage ##
Add the following to your manifest and set the admin password,
then customize the new users.

```ruby
$domain = 'xmpp.example.cmo'

# Install ejabberd and add admin user for web console
class {'ejabberd':
  admin_user => 'admin',
  admin_pass => 'password',
  domain     => $domain
}

# Create initial users
ejabberd::user {'my_user':
  domain   => $domain,
  password => 'password',
  require  => Class['ejabberd']
}
```
