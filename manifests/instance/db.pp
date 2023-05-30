# == Defined type: wordpress::instance::db
#
# This defined type manages a wordpress database instance
#
# === Parameters
#
# [*create_db*]
#   Specifies whether to create the db or not. Default: true
#
# [*create_db_user*]
#   Specifies whether to create the db user or not. Default: true
#
# [*db_name*]
#   Specifies the database name which the wordpress module should be configured
#   to use. Default: wordpress
#
# [*db_host*]
#   Specifies the database host to connect to. Default: localhost
#
# [*db_user*]
#   Specifies the database user. Default: wordpress
#
# [*db_password*]
#   Specifies the database user's password in plaintext. Default: password
#
define wordpress::instance::db (
  Boolean $create_db,
  Boolean $create_db_user,
  String $db_name,
  String $db_host,
  String $db_user,
  String $db_password,
) {
  ## Set up DB using puppetlabs-mysql defined type
  if $create_db {
    mysql_database { "${db_host}/${db_name}":
      name    => $db_name,
      charset => 'utf8',
    }
  }
  if $create_db_user {
    mysql_user { "${db_user}@${db_host}":
      password_hash => mysql::password($db_password),
    }
    mysql_grant { "${db_user}@${db_host}/${db_name}.*":
      table      => "${db_name}.*",
      user       => "${db_user}@${db_host}",
      privileges => ['ALL'],
    }
  }
}
