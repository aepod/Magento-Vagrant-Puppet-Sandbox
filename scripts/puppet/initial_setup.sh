#!/bin/bash

if [[ ! -f ".vagrantlocks/puppetmaster" ]]; then
	echo "Configuring puppetmaster with alternate names"
	#sed -i '14i\ \ \ \ dns_alt_names = puppet,puppet.idealphp.com' /etc/puppet/puppet.conf
	rm -rf /etc/puppet
	ln -s /vagrant/puppet /etc/puppet
	puppet master
    touch .vagrantlocks/puppetmaster
    echo 'Started puppetmaster'
fi

