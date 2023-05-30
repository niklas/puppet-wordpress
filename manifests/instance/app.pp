# == Defined type: wordpress::instance::app
#
# This defined type manages a wordpress application instance
#
# === Parameters
#
# [*install_dir*]
#   Specifies the directory into which wordpress should be installed. Default:
#   /opt/wordpress
#
# [*install_url*]
#   Specifies the url from which the wordpress tarball should be downloaded.
#   Default: https://wordpress.org
#
# [*version*]
#   Specifies the version of wordpress to install. Default: 4.8.1
#
# [*db_name*]
#   Specifies the database name which the wordpress module should be configured
#   to use. Required.
#
# [*db_host*]
#   Specifies the database host to connect to. Default: localhost
#
# [*db_user*]
#   Specifies the database user. Required.
#
# [*db_password*]
#   Specifies the database user's password in plaintext. Default: password
#
# [*wp_owner*]
#   Specifies the owner of the wordpress files. Default: root
#
# [*wp_group*]
#   Specifies the group of the wordpress files. Default: 0 (*BSD/Darwin
#   compatible GID)
#
# [*wp_config_owner*]
#   Specifies the other of the wordpress wp-config.php.  You must ensure this
#   user exists as this module does not attempt to create it if missing.
#   Default: $wp_owner value.
#
# [*wp_config_group*]
#   Specifies the group of the wordpress wp-config.php. Default: $pw_group value.
#
# [*wp_config_mode*]
#   Specifies the file permissions of wp-config.php. Default: 0644
#
# [*manage_wp_content*]
#   Specifies whether the wp-content directory should be managed. Default: `false`.
#
# [*wp_content_owner*]
#   Specifies the owner of the wordpress wp-content directory. Default: $wp_owner value.
#
# [*wp_content_group*]
#   Specifies the group of the wordpress wp-content directory. Default: $wp_group value.
#
# [*wp_content_recurse*]
#   Specifies whether to recursively manage the permissions on wp-content. Default: true
#
# [*wp_lang*]
#   WordPress Localized Language. Default: ''
#
# [*wp_config_content*] Specifies the entire content for wp-config.php.
#   This causes many of the other parameters to be ignored and allows an entirely custom config to be passed.
#   It is recommended to use wp_additional_config instead of this parameter when possible.
#
# [*wp_plugin_dir*]
#   WordPress Plugin Directory. Full path, no trailing slash. Default: WordPress Default
#
# [*wp_additional_config*]
#   Specifies a template to include near the end of the wp-config.php file to add additional options. Default: ''
#
# [*wp_table_prefix*]
#   Specifies the database table prefix. Default: wp_
#
# [*wp_proxy_host*]
#   Specifies a Hostname or IP of a proxy server for Wordpress to use to install updates, plugins, etc. Default: ''
#
# [*wp_proxy_port*]
#   Specifies the port to use with the proxy host.  Default: ''
#
# [*wp_site_url*]
#  If your WordPress server is behind a proxy, you might need to set the WP_SITEURL with this parameter.  Default: `undef`
#
# [*wp_multisite*]
#   Specifies whether to enable the multisite feature. Requires `wp_site_domain` to also be passed. Default: `false`
#
# [*wp_site_domain*]
#   Specifies the `DOMAIN_CURRENT_SITE` value that will be used when configuring multisite.
#   Typically this is the address of the main wordpress instance.  Default: ''
#
# [*wp_debug*]
#   Specifies the `WP_DEBUG` value that will control debugging. This must be true if you use the next two debug extensions. Default: 'false'
#
# [*wp_debug_log*]
#   Specifies the `WP_DEBUG_LOG` value that extends debugging to cause all errors to also be saved to a debug.log logfile
#   inside the /wp-content/ directory. Default: 'false'
#
# [*wp_debug_display*]
#   Specifies the `WP_DEBUG_DISPLAY` value that extends debugging to cause debug messages to be shown inline, in HTML pages.
#   Default: 'false'
#
define wordpress::instance::app (
  Stdlib::Absolutepath $install_dir,
  String $install_url,
  String $version,
  String $db_name,
  String $db_host,
  String $db_user,
  String $db_password,
  String $wp_owner,
  String $wp_group,
  String $wp_config_owner,
  String $wp_config_group,
  String $wp_config_mode,
  Boolean $manage_wp_content,
  String $wp_content_owner,
  String $wp_content_group,
  Boolean $wp_content_recurse,
  String $wp_lang,
  String $wp_plugin_dir,
  String $wp_additional_config,
  String $wp_table_prefix,
  String $wp_proxy_host,
  String $wp_proxy_port,
  Boolean $wp_multisite,
  String $wp_site_domain,
  Boolean $wp_debug,
  Boolean $wp_debug_log,
  Boolean $wp_debug_display,
  Optional[String] $wp_config_content = undef,
  Optional[String] $wp_site_url       = undef,
) {
  if $wp_config_content and ($wp_lang or $wp_debug or $wp_debug_log or $wp_debug_display or
  $wp_proxy_host or $wp_proxy_port or $wp_multisite or $wp_site_domain) {
    warning(
      'When $wp_config_content is set, the following parameters are ignored: ' +
      '$wp_table_prefix, $wp_lang, $wp_debug, $wp_debug_log, $wp_debug_display, $wp_plugin_dir, ' +
      '$wp_proxy_host, $wp_proxy_port, $wp_multisite, $wp_site_domain, $wp_additional_config'
    )
  }

  if $wp_multisite and ! $wp_site_domain {
    fail('wordpress class requires `wp_site_domain` parameter when `wp_multisite` is true')
  }

  if $wp_debug_log and ! $wp_debug {
    fail('wordpress class requires `wp_debug` parameter to be true, when `wp_debug_log` is true')
  }

  if $wp_debug_display and ! $wp_debug {
    fail('wordpress class requires `wp_debug` parameter to be true, when `wp_debug_display` is true')
  }

  if $wp_proxy_host and !empty($wp_proxy_host) {
    $exec_environment = [
      "http_proxy=http://${wp_proxy_host}:${wp_proxy_port}",
      "https_proxy=http://${wp_proxy_host}:${wp_proxy_port}",
    ]
  } else {
    $exec_environment = []
  }

  ## Resource defaults
  File {
    owner  => $wp_owner,
    group  => $wp_group,
    mode   => '0644',
  }
  Exec {
    path        => ['/bin','/sbin','/usr/bin','/usr/sbin'],
    cwd         => $install_dir,
    environment => $exec_environment,
    logoutput   => 'on_failure',
  }

  ## Installation directory
  if ! defined(File[$install_dir]) {
    file { $install_dir:
      ensure  => directory,
      recurse => true,
    }
  } else {
    notice("Warning: cannot manage the permissions of ${install_dir}, as another resource (perhaps apache::vhost?) is managing it.")
  }

  ## tar.gz. file name lang-aware
  if $wp_lang and !empty($wp_lang) {
    $install_file_name = "wordpress-${version}-${wp_lang}.tar.gz"
  } else {
    $install_file_name = "wordpress-${version}.tar.gz"
  }

  ## Download and extract
  exec { "Download wordpress ${install_url}/wordpress-${version}.tar.gz to ${install_dir}":
    command => "curl -L -O ${install_url}/${install_file_name}",
    creates => "${install_dir}/${install_file_name}",
    require => File[$install_dir],
    user    => $wp_owner,
    group   => $wp_group,
  }
  -> exec { "Extract wordpress ${install_dir}":
    command => "tar zxvf ./${install_file_name} --strip-components=1",
    creates => "${install_dir}/index.php",
    user    => $wp_owner,
    group   => $wp_group,
  }
  ~> exec { "Change ownership ${install_dir}":
    command     => "chown -R ${wp_owner}:${wp_group} ${install_dir}",
    refreshonly => true,
    user        => $wp_owner,
    group       => $wp_group,
  }

  if $manage_wp_content {
    file { "${install_dir}/wp-content":
      ensure  => directory,
      owner   => $wp_content_owner,
      group   => $wp_content_group,
      recurse => $wp_content_recurse,
      require => Exec["Extract wordpress ${install_dir}"],
    }
  }

  ## Configure wordpress
  #
  concat { "${install_dir}/wp-config.php":
    owner   => $wp_config_owner,
    group   => $wp_config_group,
    mode    => $wp_config_mode,
    require => Exec["Extract wordpress ${install_dir}"],
  }
  if $wp_config_content {
    concat::fragment { "${install_dir}/wp-config.php body":
      target  => "${install_dir}/wp-config.php",
      content => $wp_config_content,
      order   => '20',
    }
  } else {
    # Template uses no variables
    file { "${install_dir}/wp-keysalts.php":
      ensure  => file,
      content => template('wordpress/wp-keysalts.php.erb'),
      replace => false,
      require => Exec["Extract wordpress ${install_dir}"],
    }
    concat::fragment { "${install_dir}/wp-config.php keysalts":
      target  => "${install_dir}/wp-config.php",
      source  => "${install_dir}/wp-keysalts.php",
      order   => '10',
      require => File["${install_dir}/wp-keysalts.php"],
    }
    # Template uses:
    # - $db_name
    # - $db_user
    # - $db_password
    # - $db_host
    # - $wp_table_prefix
    # - $wp_lang
    # - $wp_plugin_dir
    # - $wp_proxy_host
    # - $wp_proxy_port
    # - $wp_site_url
    # - $wp_multisite
    # - $wp_site_domain
    # - $wp_additional_config
    # - $wp_debug
    # - $wp_debug_log
    # - $wp_debug_display
    concat::fragment { "${install_dir}/wp-config.php body":
      target  => "${install_dir}/wp-config.php",
      content => template('wordpress/wp-config.php.erb'),
      order   => '20',
    }
  }
}
