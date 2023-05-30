# == Class: wordpress::app
#
# This class manages wordpress application layer
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
class wordpress::app (
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
  String $wp_config_content,
  String $wp_plugin_dir,
  String $wp_additional_config,
  String $wp_table_prefix,
  String $wp_proxy_host,
  String $wp_proxy_port,
  String $wp_site_url,
  Boolean $wp_multisite,
  String $wp_site_domain,
  Boolean $wp_debug,
  Boolean $wp_debug_log,
  Boolean $wp_debug_display,
) {
  wordpress::instance::app { $install_dir:
    install_dir          => $install_dir,
    install_url          => $install_url,
    version              => $version,
    db_name              => $db_name,
    db_host              => $db_host,
    db_user              => $db_user,
    db_password          => $db_password,
    wp_owner             => $wp_owner,
    wp_group             => $wp_group,
    wp_config_owner      => $wp_config_owner,
    wp_config_group      => $wp_config_group,
    wp_config_mode       => $wp_config_mode,
    manage_wp_content    => $manage_wp_content,
    wp_content_owner     => $wp_content_owner,
    wp_content_group     => $wp_content_group,
    wp_content_recurse   => $wp_content_recurse,
    wp_lang              => $wp_lang,
    wp_plugin_dir        => $wp_plugin_dir,
    wp_additional_config => $wp_additional_config,
    wp_table_prefix      => $wp_table_prefix,
    wp_proxy_host        => $wp_proxy_host,
    wp_proxy_port        => $wp_proxy_port,
    wp_site_url          => $wp_site_url,
    wp_multisite         => $wp_multisite,
    wp_site_domain       => $wp_site_domain,
    wp_debug             => $wp_debug,
    wp_debug_log         => $wp_debug_log,
    wp_debug_display     => $wp_debug_display,
  }
}
