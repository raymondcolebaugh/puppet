# Create a MySQL Database
define mysql::database(
  $mysql_root,
  $db = $title,
  $user = $title,
  $pass = $title,
) {
  exec {"${title}-db":
    unless  => "mysql -u ${title} -p'${pass}' ${db}",
    command => "mysql -u root -p'${mysql_root}' -e '
        CREATE USER ${title}@localhost
          IDENTIFIED BY \"${pass}\";
        CREATE DATABASE ${db};
        GRANT ALL ON ${db}.* TO ${title}@localhost;
        FLUSH PRIVILEGES;'",
    require => [User[$title], Class['mysql']]
  }
}
