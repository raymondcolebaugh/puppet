# Create a MySQL Database
define mysql::database(
  $mysql_root,
  $db = $title,
  $user = $title,
  $pass = $title,
  $host = 'localhost',
) {
  exec {"${title}-db":
    unless  => "mysql -u ${title} -p'${pass}' -h ${host} ${db}",
    command => "mysql -u root -p'${mysql_root}' -h ${host} -e '
        CREATE USER ${title}@localhost
          IDENTIFIED BY \"${pass}\";
        CREATE DATABASE ${db};
        GRANT ALL ON ${db}.* TO ${title}@localhost;
        FLUSH PRIVILEGES;'",
    require => [User[$title], Class['mysql']]
  }
}
