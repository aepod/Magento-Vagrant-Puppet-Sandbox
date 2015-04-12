# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_url = "https://vagrantcloud.com/puppetlabs/boxes/centos-6.6-64-puppet"

  # BOX: puppet
  # Puppetmaster server - Must be provisioned and up for any puppet to work correctly
  # This should always be brought up first.
  config.vm.define "puppet" do |puppet|
	puppet.vm.hostname = "puppet"
	puppet.vm.network "private_network", ip: "192.168.200.10"
	puppet.vm.provision "shell", path: "scripts/initial_common.sh"
	puppet.vm.provision "shell", path: "scripts/puppet/initial_setup.sh"
  end

  # BOX: db
  # Mysql, Redis and File Server
  # This should always be brought up before the initial web node
  config.vm.define "db" do |db|
	db.vm.hostname = "db"
	db.vm.network "private_network", ip: "192.168.200.11"
	db.vm.provision "shell", path: "scripts/initial_common.sh"
	db.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
	db.vm.provision "shell", path: "scripts/db/initial_setup.sh"
    db.vm.provision "puppet_server" do |puppet|
      puppet.puppet_node = "db.localdomain"
    end			
  end  

  # BOX: web
  # haproxy, default ip for web site
  # Initial checkout and install of magento on this server
  # Would be used for deployments in future versions
  config.vm.define "web" do |web|
	web.vm.hostname = "web"
	web.vm.network "private_network", ip: "192.168.200.12"
    web.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"] = "512"
    end
    web.vm.provider "vmware_workstation" do |v|
        v.vmx["memsize"] = "512"
    end
 
    web.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "512"
    end
 
    web.vm.provider "virtualbox" do |v|
        v.customize [ "modifyvm", :id, "--memory", "512" ]
    end	
    web.vm.provision "shell", path: "scripts/initial_common.sh"
    web.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
	web.vm.provision "shell", path: "scripts/web/initial_setup.sh"
    web.vm.provision "puppet_server" do |puppet|
      puppet.puppet_node = "web.localdomain"
    end	
	web.vm.provision "shell", path: "scripts/web/magento_setup.sh"
  end    
  
  # BOX: render[n]
  # Render nodes have nginx and php-fpm
  config.vm.define "render1" do |render1|
	render1.vm.hostname = "render1"
	render1.vm.network "private_network", ip: "192.168.200.13"
	render1.vm.provision "shell", path: "scripts/initial_common.sh"
	render1.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
    render1.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end  
  config.vm.define "render2",autostart:false do |render2|
	render2.vm.hostname = "render2"
	render2.vm.network "private_network", ip: "192.168.200.14"
	render2.vm.provision "shell", path: "scripts/initial_common.sh"
	render2.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
    render2.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end    
  config.vm.define "render3",autostart:false do |render3|
	render3.vm.hostname = "render3"
	render3.vm.network "private_network", ip: "192.168.200.15"
	render3.vm.provision "shell", path: "scripts/initial_common.sh"
	render3.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
    render3.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end    
  config.vm.define "render4",autostart:false do |render4|
	render4.vm.hostname = "render4"
	render4.vm.network "private_network", ip: "192.168.200.16"
	render4.vm.provision "shell", path: "scripts/initial_common.sh"
	render4.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
    render4.vm.provision "shell", path: "scripts/render/initial_setup.sh"
  end    

 
  # BOX: jmeter
  # Java installed, and then the MPT is installed
  # See: /usr/local/apache-jmeter-2.13/
  config.vm.define "jmeter",autostart:false do |jmeter|
	jmeter.vm.hostname = "jmeter"
	jmeter.vm.network "private_network", ip: "192.168.200.20"
    jmeter.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"] = "512"
    end
    jmeter.vm.provider "vmware_workstation" do |v|
        v.vmx["memsize"] = "512"
    end
 
    jmeter.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "512"
    end
 
    jmeter.vm.provider "virtualbox" do |v|
        v.customize [ "modifyvm", :id, "--memory", "512" ]
    end
	jmeter.vm.provision "shell", path: "scripts/initial_common.sh"
	jmeter.vm.provision "shell", path: "scripts/jmeter/initial_setup.sh"
  end  
     
  # BOX: Monolith
  # One box to rule them all.. ok so web/db/redis ready to go
  config.vm.define "monolith",autostart:false do |monolith|
	monolith.vm.hostname = "monolith"
    monolith.vm.provider "vmware_fusion" do |v|
        v.vmx["memsize"] = "2048"
    end
    monolith.vm.provider "vmware_workstation" do |v|
        v.vmx["memsize"] = "2048"
    end
 
    monolith.vm.provider "vmware_desktop" do |v|
        v.vmx["memsize"] = "2048"
    end
 
    monolith.vm.provider "virtualbox" do |v|
        v.customize [ "modifyvm", :id, "--memory", "2048" ]
    end	
	monolith.vm.network "private_network", ip: "192.168.200.21"
	monolith.vm.provision "shell", path: "scripts/initial_common.sh"
	monolith.vm.provision "shell", path: "scripts/initial_puppetcert.sh"
	monolith.vm.provision "shell", path: "scripts/monolith/initial_setup.sh"
	monolith.vm.provision "shell", path: "scripts/monolith/magento_setup.sh"    
  end    
     
     
     
end
