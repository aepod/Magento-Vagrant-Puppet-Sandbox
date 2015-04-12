#!/bin/bash

if [[ ! -d ".vagrantlocks" ]]; then
    mkdir .vagrantlocks
    echo 'Created vagrant lock directory in ~/.vagrantlocks'
fi

if [[ ! -f ".vagrantlocks/iptables" ]]; then
	echo "Disable IP Tables for the demo"
	service iptables stop
	chkconfig iptables off
    touch .vagrantlocks/iptables
fi

if [[ ! -f ".vagrantlocks/sshkey" ]]; then
	echo "Adding shared root key, for self-signing etc"
	if [[ ! -d "/root/.ssh/" ]]; then
		mkdir /root/.ssh/
	fi
	cp /vagrant/ssh/* /root/.ssh/
	cat /vagrant/ssh/id_rsa.pub > /root/.ssh/authorized_keys
	chmod -R 600 /root/.ssh/	
    touch .vagrantlocks/sshkey
fi


if [[ ! -f ".vagrantlocks/baseyum" ]]; then
	echo "Doing some initial yum installing"
	rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/epel-release-6-5.noarch.rpm  &> /dev/null
    rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-13.ius.centos6.noarch.rpm  &> /dev/null
	yum -y install pv nano telnet man vim bash-completion &> /dev/null
    touch .vagrantlocks/baseyum
fi

if [[ ! -f ".vagrantlocks/hosts" ]]; then
	sed -i '1s/.*/127.0.0.1\tlocalhost/' /etc/hosts
	echo "192.168.200.10	puppet puppet.idealphp.com puppet.localdomain" >> /etc/hosts
	echo "192.168.200.11	db db.idealphp.com db.localdomain" >> /etc/hosts
	echo "192.168.200.12	web web.idealphp.com web.localdomain www.idealphp.com" >> /etc/hosts
	echo "192.168.200.13	render1 render1.localdomain" >> /etc/hosts
	echo "192.168.200.14	render2 render2.localdomain" >> /etc/hosts
	echo "192.168.200.15	render3 render3.localdomain" >> /etc/hosts
	echo "192.168.200.16	render4 render4.localdomain" >> /etc/hosts
	echo "192.168.200.20	jmeter jmeter.localdomain jmeter.idealphp.com" >> /etc/hosts
	echo "192.168.200.21	monolith monolith.localdomain" >> /etc/hosts
    touch .vagrantlocks/hosts
    echo 'Added things to /etc/hosts'
fi


