#!/bin/bash

CURRENT_HOST=$(hostname)."localdomain"

if [[ ! -f ".vagrantlocks/puppetagent" ]]; then
	echo "Configuring puppet agent and self signing with puppetmaster"
	ssh -oStrictHostKeyChecking=no root@puppet puppet cert clean $CURRENT_HOST
	service puppet restart
	sleep 5
	ssh -oStrictHostKeyChecking=no root@puppet puppet cert sign --all
    touch .vagrantlocks/puppetagent
    echo 'Puppet Agent should be signed and ready to go'
fi

