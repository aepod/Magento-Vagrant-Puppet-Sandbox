# Version of MySQL you want. At the time of this writing (2014-09-09) it can be 5.5 or 5.6.
$mysqlversion = "5.6"

# Root password of all of the MySQL/MariaDB servers...
$mysqlrootpw = 'du9bnd7und30988'

# Mysql Override options - https://forge.puppetlabs.com/puppetlabs/mysql
$override_options = { }

# Name of the Base URL for sites in this instance...
$baseurl = "www.idealphp.com"

# Used by NFS setup
$privatesubnet = "192.168.200.0/24"

# UID of the webserver, the account name is "wwwusr"
$wwwuid = "800"

$sharedstoragetarget = "/shared"

########################################################################
#               You needn't go below here much, ideally                #
#  Node definitions can also be done with an ENC like LDAP or Foreman  #
########################################################################

import "functions.pp"
include utilities::nscd
include utilities::useful

  
node 'puppet' {

}

node 'db' {

	$override_options = {
	  'mysqld' => {
	    'bind-address' => '192.168.200.11',
	  }
	}
	class { '::mysql::server':
	  root_password           => $mysqlrootpw,
	  remove_default_accounts => true,
	  override_options        => $override_options
	}
	mysql::db { 'magento':
	  user     => 'magento',
	  password => '5678password',
	  host     => '%',
	  grant    => ['ALL'],
	}
	
	class { 'redis':
	}
	redis::instance { 'redis-6380':
	  redis_port         => '6380',
	  redis_max_memory   => '1gb',
	}
	redis::instance { 'redis-6381':
	  redis_port         => '6381',
	  redis_max_memory   => '1gb',
	}
	include daemons::nginx::usergroup
	include nfs::server
	
}

  
node 'monolith' {
	$override_options = {
	  'mysqld' => {
	    'bind-address' => '192.168.200.21',
	  }
	}
	class { '::mysql::server':
	  root_password           => $mysqlrootpw,
	  remove_default_accounts => true,
	  override_options        => $override_options
	}
	mysql::db { 'magento':
	  user     => 'magento',
	  password => '5678password',
	  host     => '%',
	  grant    => ['ALL'],
	}
	
	class { 'redis':
	}
	redis::instance { 'redis-6380':
	  redis_port         => '6380',
	  redis_max_memory   => '1gb',
	}
	redis::instance { 'redis-6381':
	  redis_port         => '6381',
	  redis_max_memory   => '1gb',
	}
	include daemons::nginx::usergroup
	include nfs::server
	include daemons::nginx::server
	include daemons::nginx::php
}



node /render\d+.*/ {
	include daemons::nginx::usergroup
	include daemons::nginx::server
	include daemons::nginx::php
	include nfs::client
}

node 'web' {
class { 'haproxy':
  global_options   => {
    'maxconn' => '8000'
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => 'enable',
    'option'  => 'redispatch',
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
}  
  haproxy::listen { 'web':
    collect_exported => false,
    ipaddress        => '192.168.200.12',
    ports            => '80',
    mode			 => 'http',
	  options   => {
	    'option'  => [
	      'httpchk GET /',
	    ],
	    'balance' => 'leastconn',
	  },    
  }
  haproxy::balancermember { 'render1':
    listening_service => 'web',
    server_names      => 'render1',
    ipaddresses       => '192.168.200.13',
    ports             => '80',
	options           => 'check',  
  }
  haproxy::balancermember { 'render2':
    listening_service => 'web',
    server_names      => 'render2',
    ipaddresses       => '192.168.200.14',
    ports             => '80',
    options           => 'check',     
  }
  haproxy::balancermember { 'render3':
    listening_service => 'web',
    server_names      => 'render3',
    ipaddresses       => '192.168.200.15',
    ports             => '80',
    options           => 'check',     
  }
  haproxy::balancermember { 'render4':
    listening_service => 'web',
    server_names      => 'render4',
    ipaddresses       => '192.168.200.16',
    ports             => '80',
    options           => 'check',     
  }
  include daemons::nginx::usergroup
  include daemons::nginx::php
  include nfs::client
}