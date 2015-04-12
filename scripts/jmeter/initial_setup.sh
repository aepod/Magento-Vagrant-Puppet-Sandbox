#!/bin/bash

if [[ ! -f ".vagrantlocks/jmeter" ]]; then
	echo "Installing Java prerequirement for JMeter"
	yum install -y java &> /dev/null
	
	cd /root/
	wget http://apache.mirrors.lucidnetworks.net//jmeter/binaries/apache-jmeter-2.13.tgz -O /root/jmeter.tgz &> /dev/null
	wget https://github.com/aepod/magento-performance-toolkit/archive/master.zip -O /root/mpt.zip &> /dev/null
	wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.2.1.zip &> /dev/null
	wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.1.zip &> /dev/null
	unzip mpt.zip &> /dev/null
	
	echo "Installing jmeter into /usr/local/apache-jmeter-2.13/"
	cd /usr/local
	tar -zxvf /root/jmeter.tgz &> /dev/null
	cd  /usr/local/apache-jmeter-2.13/
	echo "Installing jmeter plugins required by MPT"
	unzip -n /root/JMeterPlugins-Extras-1.2.1.zip
	unzip -n /root/JMeterPlugins-Standard-1.2.1.zip
	
	echo "Installing MPT jmeter test into /usr/local/apache-jmeter-2.13/"	
	mkdir -p /usr/local/apache-jmeter-2.13/tests/
	cp /root/magento-performance-toolkit-master/1.9ce/benchmark.jmx /usr/local/apache-jmeter-2.13/tests/
	cp /root/magento-performance-toolkit-master/1.9ce/benchmark.jmx /usr/local/apache-jmeter-2.13/tests/benchmark-default.jmx
	
	cd /home/vagrant/
    touch .vagrantlocks/jmeter

fi
