<?php
$CONFIG = array (
  'instanceid' => '',
  'passwordsalt' => '',
  'secret' => '',
  'trusted_domains' => 
  array (
    0 => '@@DOMAIN@@',
  ),
  'enable_previews' => true,
  'datadirectory' => '/shares/cloud/nextcloud_data',
  'dbtype' => 'mysql',
  'version' => '17.0.0.0',
  'overwrite.cli.url' => 'https://@@DOMAIN@@/nextcloud',
  'dbname' => 'nextcloud',
  'dbhost' => '127.0.0.1',
  'dbport' => '3307',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => '@@ADMIN_PWD@@',
  'installed' => true,
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'memcache.local' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'localhost',
    'port' => '6379',
  ),
  'maintenance' => false,
  'preview_max_x' => '2048',
  'preview_max_y' => '2048',
  'jpeg_quality' => '60',
);
