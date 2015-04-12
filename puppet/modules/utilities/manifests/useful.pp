class utilities::useful {

	package {
		"htop":
			ensure => present;
	}

	@@host {
		"$::fqdn":
			host_aliases => "$::hostname",
			ip => "$::servicenet_ipaddr",
			tag => "announce";
	}

	Host <<| tag == "announce" |>>

}
