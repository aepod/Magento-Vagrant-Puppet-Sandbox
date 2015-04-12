class daemons::nginx::server ( ) {

	package {
		"nginx":
			ensure => present;
	}

	service {
		"nginx":
			ensure => running,
			enable => true,
			require => Package["nginx"];
	}

	file {
		"/etc/nginx/nginx.conf":
			content => template("daemons/nginx.conf"),
			require => Package["nginx"],
			notify => Service["nginx"];
		"/var/lib/nginx":
			owner => "wwwusr",
			group => "wwwusr",
			mode => "770",
			require => [ User["wwwusr"], Group["wwwusr"], Package["nginx"] ];
		"/var/lib/nginx/tmp":
			owner => "wwwusr",
			group => "wwwusr",
			mode => "770",
			require => File["/var/lib/nginx"];
		"/var/lib/nginx/tmp/proxy":
			owner => "wwwusr",
			group => "wwwusr",
			mode => "770",
			require => File["/var/lib/nginx/tmp"];
	}


}
