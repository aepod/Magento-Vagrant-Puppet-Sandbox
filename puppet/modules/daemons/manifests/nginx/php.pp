class daemons::nginx::php ( ) {

	package {
		"php-fpm":
			ensure => present;
		"php-pecl-zendopcache":
			ensure => present;
		"php-mysql":
			ensure => present;
		"php-pdo":
			ensure => present;
		"php-xml":
			ensure => present;
		"php-gd":
			ensure => present;
		"php-mcrypt":
			ensure => present;
	}

	service {
		"php-fpm":
			ensure => running,
			enable => true,
			require => [ Package["php-fpm"], Package["php-pecl-zendopcache"], Package["php-mysql"], Package["php-pdo"] ];
	}

	change_param {
		"set php opcache no state":
			file => "/etc/php.d/opcache.ini",
			param => "opcache.validate_timestamps",
			value => "0",
			notify => Service["php-fpm"],
			require => Package["php-pecl-zendopcache"];
		"set fpm max children":
			file => "/etc/php-fpm.d/www.conf",
			param => "pm.max_children",
			value => "8",
			separator=> " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set fpm max spare severs":
			file => "/etc/php-fpm.d/www.conf",
			param => "pm.max_spare_servers",
			value => "5",
			separator=> " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set fpm user":
			file => "/etc/php-fpm.d/www.conf",
			param => "user",
			value => "$::wwwuid",
			separator=> " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set fpm group":
			file => "/etc/php-fpm.d/www.conf",
			param => "group",
			value => "$::wwwuid",
			separator=> " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set fpm session dir":
			file => "/etc/php-fpm.d/www.conf",
			param => "php_value\[session\.save_path\]",
			value => "$::sharedstoragetarget/sessions",
			separator => " = ",
			matchfor => "php_value\[session\.save_path\] = $::sharedstoragetarget/sessions",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set php timezone":
			file => "/etc/php.ini",
			param => "date.timezone",
			value => "America/New_York",
			separator => " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"set php memory":
			file => "/etc/php.ini",
			param => "memory_limit",
			value => "256M",
			separator => " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
		"php fixpathinfo":
			file => "/etc/php.ini",
			param => "cgi.fix_pathinfo",
			value => "0",
			separator => " = ",
			notify => Service["php-fpm"],
			require => Package["php-fpm"];
	}

}
