# -*- mode: ruby -*-
# vi: set ft=ruby :

# This must be set manually after puppet is stood up
# Would not be needed if full qualified DNS was set
puppet_ip = "127.0.0.1"

Vagrant.configure(2) do |config|
  config.vm.box = "digital_ocean"
  config.ssh.insert_key = 'true'

  config.vm.provider :digital_ocean do |provider, override|
	# Set the token to your token you generated
    provider.token = 'TOKEN'

	# Do not change the other values here
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"	
    provider.image = 'centos-6-5-x64'
    provider.region = 'nyc3'
	provider.private_networking = true
    provider.size = '512mb' 
	
  end  
  
  # BOX: puppet
  # Puppetmaster server - Must be provisioned and up for any puppet to work correctly
  # The internal Puppet IP must be added to line 6 of this file
  # This should always be brought up first.
  config.vm.define "puppet" do |puppet|
	puppet.vm.hostname = "puppet.idealphp.com"
	puppet.vm.provision "shell", path: "scripts/initial_common.sh"
	puppet.vm.provision "shell", path: "scripts/puppet/initial_setup.sh"
	config.vm.provider :digital_ocean do |provider, override|
		provider.size = '1gb'
	end  	
  end

  # BOX: monolith
  # Mysql, Redis, Nginx, php-fpm
  # This should always be brought up before the initial web node
  config.vm.define "monolith",autostart:false do |monolith|
	monolith.vm.hostname = "monolith.idealphp.com"
	monolith.vm.provision "shell", path: "scripts/initial_common.sh"
	monolith.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
	monolith.vm.provision "shell", path: "scripts/monolith/magento_setup.sh"
	monolith.vm.provision "shell", path: "scripts/monolith/initial_setup.sh"
	config.vm.provider :digital_ocean do |provider, override|
		provider.size = '2gb'
	  end  
	monolith.vm.provision "shell", path: "scripts/output_status.sh", args: "monolith"	
  end     
  
  
  # BOX: db
  # Mysql, Redis and File Server
  # This should always be brought up before the initial web node
  config.vm.define "db",autostart:false do |db|
	db.vm.hostname = "db.idealphp.com"
	db.vm.provision "shell", path: "scripts/initial_common.sh"
	db.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
	config.vm.provider :digital_ocean do |provider, override|
		provider.size = '1gb'
	  end  
  end    
 
  # BOX: web
  # haproxy, default ip for web site
  # Initial checkout and install of magento on this server
  # Would be used for deployments in future versions
  config.vm.define "web",autostart:false do |web|
	web.vm.hostname = "www.idealphp.com"
    web.vm.provision "shell", path: "scripts/initial_common.sh"
    web.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
	web.vm.provision "shell", path: "scripts/web/magento_setup.sh"
	web.vm.provision "shell", path: "scripts/web/initial_setup.sh"	
	web.vm.provision "shell", path: "scripts/output_status.sh", args: "web"	
  end    
 
  # BOX: render[n]
  # Render nodes have nginx and php-fpm
  # Standup
  config.vm.define "render1",autostart:false do |render1|
	render1.vm.hostname = "render1.idealphp.com"
	render1.vm.provision "shell", path: "scripts/initial_common.sh"
	render1.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
    render1.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end   
  config.vm.define "render2",autostart:false do |render2|
	render2.vm.hostname = "render2.idealphp.com"
	render2.vm.provision "shell", path: "scripts/initial_common.sh"
	render2.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
    render2.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end   
  config.vm.define "render3",autostart:false do |render3|
	render3.vm.hostname = "render3.idealphp.com"
	render3.vm.provision "shell", path: "scripts/initial_common.sh"
	render3.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
    render3.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end   
  config.vm.define "render4",autostart:false do |render4|
	render4.vm.hostname = "render4.idealphp.com"
	render4.vm.provision "shell", path: "scripts/initial_common.sh"
	render4.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
    render4.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end   
 
  # BOX: jmeter
  # Java installed, and then the MPT is installed
  # See: /usr/local/apache-jmeter-2.13/
  config.vm.define "jmeter",autostart:false do |jmeter|
	jmeter.vm.hostname = "jmeter.idealphp.com"
	jmeter.vm.provision "shell", path: "scripts/initial_common.sh"
	jmeter.vm.provision "shell", path: "scripts/initial_addpuppet.sh", args: "#{puppet_ip}"
	jmeter.vm.provision "shell", path: "scripts/jmeter/initial_setup.sh"
	jmeter.vm.provision "shell", path: "scripts/output_status.sh", args: "jmeter"	
  end  
 
 
end
