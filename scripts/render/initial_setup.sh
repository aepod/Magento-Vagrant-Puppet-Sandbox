#!/bin/bash

# Running puppet here, because it fails as an provider in vagrant
puppet agent -t

if [[ ! -f ".vagrantlocks/magento" ]]; then
	# who needs a ssh-keyscan ?
	ssh -oStrictHostKeyChecking=no root@web echo "hi" &> /dev/null
	
	# copy files from web
	mkdir -p /var/www/html
	rsync -a root@web:/var/www/html/ /var/www/html/
	
	
	# Give the server a kick
	service nginx restart
	service php-fpm restart
	touch .vagrantlocks/magento
fi