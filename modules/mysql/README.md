# MySQL #
## Description ##
Popular relational database.

From mysql(1):

mysql is a simple SQL shell with input line editing capabilities. It supports interactive and noninteractive use. When used interactively,
query results are presented in an ASCII-table format. When used noninteractively (for example, as a filter), the result is presented in
tab-separated format. The output format can be changed using command options.

## Usage ##
Add the following to your manifest and customize with a strong password and your
database.

```ruby
$root_pass = 'password'

class {'mysql':
  root_pass => $root_pass
}

# Create a database and application user
mysql::database {'my_database':
  mysql_rootpw => $root_pass,
  user         => 'my_user',
  pass         => 'my_pass',
}
```
