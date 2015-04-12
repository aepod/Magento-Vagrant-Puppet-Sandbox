class nfs::client ( ) inherits nfs {

	file {
		"$::sharedstoragetarget":
			ensure => directory,
			owner => "$::wwwuid",
			group => "$::wwwuid";
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
	}

	mount {
		"$::sharedstoragetarget":
			ensure => "mounted",
			device => "192.168.200.11:/shared/",
			fstype => "nfs",
			options => "vers=3,proto=tcp,hard,intr,rsize=32768,wsize=32768,noatime,_netdev",
			atboot => true,
			require => File["$::sharedstoragetarget"];
	}
	
}
