#!/bin/bash

if [[ ! -f "/usr/local/bin/n98-magerun.phar" ]]; then
	echo "Adding n98-magerun"
	wget https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar -O /usr/local/bin/n98-magerun.phar &> /dev/null
	chmod +x /usr/local/bin/n98-magerun.phar
fi

# Just delete the whole html dir and re-provision to reinstall
if [[ ! -d "/var/www/html/" ]]; then
	mkdir -p /var/www/html/
fi

if [[ ! -d "/var/www/html/app" ]]; then
	echo "Installing Magento"
	cp /vagrant/scripts/monolith/n98-config.yaml /root/.n98-magerun.yaml
	/usr/local/bin/n98-magerun.phar install -n --dbHost="192.168.200.21" --dbUser="magento" --dbPass="5678password" --dbName="magento" --installSampleData=no --useDefaultConfigParams=yes --magentoVersionByName="magento1910" --installationFolder="/var/www/html/" --baseUrl="http://www.idealphp.com/"
	chown -R wwwusr:wwwusr /var/www/html/
fi

if [[ ! -d "/var/www/html/dev/" ]]; then
	echo "Adding mpt"
	cd /root/
	wget https://github.com/aepod/magento-performance-toolkit/archive/master.zip -O /root/mpt.zip &> /dev/null
	unzip mpt.zip &> /dev/null
	mkdir -p /var/www/html/dev/tools/performance_toolkit/
	cp -R /root/magento-performance-toolkit-master/1.9ce/* /var/www/html/dev/tools/performance_toolkit/
	cd /var/www/html/dev/tools/performance_toolkit/
	rm -rf ./tmp/
	php -f ./generate.php -- --profile=profiles/small.xml
	cd /root/
fi

if [[ ! -f "/home/vagrant/.vagrantlocks/magento" ]]; then
	# Modify app/etc/local to use redis
	cp /vagrant/scripts/monolith/local.xml /var/www/html/app/etc/
	
    touch /home/vagrant/.vagrantlocks/magento
fi


# Give the server a kick
service nginx restart
service php-fpm restart

	