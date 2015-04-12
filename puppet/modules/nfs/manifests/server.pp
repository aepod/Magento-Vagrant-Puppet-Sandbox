class nfs::server ( ) inherits nfs {

	file {
		"$::sharedstoragetarget":
			ensure => directory,
			owner => "wwwusr",
			group => "wwwusr",
			mode => 2777;
		"$::sharedstoragetarget/website":
			ensure => directory,
			owner => "wwwusr",
			group => "wwwusr",
			mode => 2777;
		"$::sharedstoragetarget/sessions":
			ensure => directory,
			owner => "wwwusr",
			group => "wwwusr",
			mode => 2777;
		"$::sharedstoragetarget/uploads":
			ensure => directory,
			owner => "wwwusr",
			group => "wwwusr",
			mode => 2777;
		"/etc/exports":
			require => File["$::sharedstoragetarget"],
			notify => Exec["export_filesystems"],
			content => "$::sharedstoragetarget	$::privatesubnet(rw,no_root_squash)";
	}

	exec {
		"export_filesystems":
			path => "/bin:/usr/bin:/sbin:/usr/sbin/",
			command => "exportfs -var",
			refreshonly => true;
	}

	service {
		"rpcbind":
			ensure => running,
			enable => true,
			require => Package["nfs-utils"];
		"nfslock":
			ensure => running,
			enable => true,
			require => Package["nfs-utils"];
		"nfs":
			ensure => running,
			enable => true,
			require => Package["nfs-utils"];
	}
	

}
