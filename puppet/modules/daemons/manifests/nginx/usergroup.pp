class daemons::nginx::usergroup ( ) {
	group {
		"wwwusr":
			ensure => present,
			gid => "$::wwwuid";
	}

	user {
		"wwwusr":
			ensure => present,
			gid => "wwwusr",
			uid => "$::wwwuid",
			require => Group["wwwusr"];
	}

}