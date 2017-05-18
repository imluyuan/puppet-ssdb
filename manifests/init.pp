# == Class: ssdb
#
# This class is used to manage ssdb services
#
# == Parameters:
#
# [*ensure_package*]
# [*port*]
# [*work_dir*]
# [*pidfile*]
# [*log_level*]
# [*log_output*]
# [*cache_size*]
# [*block_size*]
# [*compression*]
# [*enable_binlog*]
# [*enable_replication*]
# [*replication_id*]
# [*replication_type*]
# [*replication_ip*]
# [*replication_port*]
# [*config_rsyslog*]
#
class ssdb (
  $ensure_package     = present,
  $port               = '8887',
  $work_dir           = '/var/lib/ssdb/',
  $pidfile            = '/var/run/ssdb.pid',
  $log_level          = 'info',
  $log_output         = '/var/log/ssdb.log',
  $cache_size         = '500',
  $block_size         = '32',
  $compression        = 'yes',
  $enable_binlog      = false,
  $enable_replication = false,
  $replication_id     = undef,
  $replication_type   = 'mirror',
  $replication_host    = '127.0.0.1',
  $replication_port   = '8888',
  $readonly           = 'no',
  $config_rsyslog     = false,
){

  package { 'ssdb':
    ensure => $ensure_package,
  }

  file { 'ssdb.conf':
    ensure  => present,
    path    => '/etc/ssdb/ssdb.conf',
    content => template('ssdb/ssdb.conf.erb')
  }

  service { 'ssdb-server':
    name       => 'ssdb-server',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => File['ssdb.conf']
  }

  if $config_rsyslog {
    # Rsyslog configuration
    ::rsyslog::imfile { 'ssdb':
      file_name        => "$log_output",
      file_tag         => 'ssdb',
      file_facility    => 'local3',
      polling_interval => 3,
    }
  }
}