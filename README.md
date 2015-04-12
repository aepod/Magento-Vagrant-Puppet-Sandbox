# Magento-Puppet-Cluster

A vagrant puppet cluster for demonstrating how to use haproxy to load balance web nodes and single database. 

The vagrant box is `puppetlabs/centos-6.6-64-puppet` this includes both virtualbox and VMware providers.

The overall puppet configurations is simplified, and not dynamic. This will be added to the configurations in the near future.

---
There are a few things that are not production ready:

1. Root password is: `puppet`. You can login as root on SSH.
2. Root has a shared key between boxes, this is for self-signing on puppet
3. Pupppet master is gimped overall, its not controlled via puppet and its not running passenger
4. It uses www.idealphp.com as its domain and sets a network of secondary IP's to make it easier to demonstrate:

```
192.168.200.10  puppet puppet.idealphp.com puppet.localdomain

192.168.200.11  db db.idealphp.com db.localdomain
192.168.200.12  web web.idealphp.com web.localdomain www.idealphp.com
192.168.200.13  render1 render1.localdomain
192.168.200.14  render2 render2.localdomain
192.168.200.15  render3 render3.localdomain
192.168.200.16  render4 render4.localdomain
192.168.200.20  jmeter
192.168.200.21  monolith 

```
---
To use this:

1. Install vagrant
2. Checkout from github
3. CMD Prompt in the directory you checked out
4. `vagrant up` this will load 4 boxes: puppet,db,web,render1 (render2-4 and jmeter do not autostart)
5. Add `192.168.200.12  www.idealphp.com` to you local hosts file and point a browser at it.

---
Monolith: 
A single box, with web, db, redis. Still requires the puppetmaster to be up. 
To use:

1. Ensure puppet is up `vagrant up puppet`
2. Bring up monolith `vagrant up monolith`
3. Change your DNS entry for www.idealphp.com to 192.168.20.21 (This is sort of a pain sorry)
4. Point your web browser or test scripts there

---
Magento Performance Toolkit:

For some background see: http://aepod.com/using-the-magento-performance-toolkit/

This gets installed and run with the standup on the web servers. You do not need to import the profiles etc, if you ran the magento setup scripts with the stand up, everything should be automated.

You will need to standup the jmeter server to use the built in jmeter tests. Look in /usr/local/apache-jmeter/ you will find the Java and jmeter already installed, and the tests will be in the tests/ directory. You may need to edit the host file if you are testing against monolith.

To Use: TBD

---

haproxy stats available once web is up at: 
http://www.idealphp.com/haproxy?stats

---
Puppet Modules:

- MySQL: https://forge.puppetlabs.com/puppetlabs/mysql
- Redis: https://forge.puppetlabs.com/thomasvandoren/redis
- HAProxy: https://forge.puppetlabs.com/puppetlabs/haproxy

---
TODO:

1. Improve haproxy (check is not looking at php, only nginx)
2. Improve Puppet, make cluster dynamic
3. Puppet the install_scripts and puppet master server
4. Clean up Root password crap


---
The MIT License (MIT)

Copyright (c) 2015 Mathew Beane
See LICENSE.txt for full license
