define change_param($file, $param, $value, $refreshonly = 'false', $separator = '=', $matchfor="") {
	if $matchfor == "" {
		$realmatchfor="$param$separator$value"
	} else {
		$realmatchfor="$matchfor"
	}
	exec { "/bin/grep -q '^$param$separator.*' '$file' && /usr/bin/perl -pi -e 's|^$param$separator.*|$param$separator$value|g' '$file' || echo '$param$separator$value' >> '$file' ":
		unless => "/bin/grep -xqe '$realmatchfor' '$file'",
		path => "/bin:/usr/bin",
		refreshonly => $refreshonly
	}
}
