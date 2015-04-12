class utilities::nscd {

	package {
		"nscd":
			ensure => present;
	}

	service {
		"nscd":
			ensure => running,
			enable => true,
			require => Package["nscd"];
	}

}
