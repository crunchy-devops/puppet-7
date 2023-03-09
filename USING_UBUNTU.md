# Puppet on Ubuntu

## Gateway host

```shell
# ssh to gateway host provided 
sh connect.sh
# check the prompt
```

## Install PuppetServer
```shell
sudo apt-get update -y
wget https://apt.puppetlabs.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt-get update -y
sudo apt-get install puppetserver -y
sudo tac /etc/default/puppetserver # reverse edit of puppetserver configuration 
# commands for changing puppetserver memory footprint
sudo grep ARGS /etc/default/puppetserver  # Get puppetserver memory parameters
sudo grep 2g /etc/default/puppetserver  # Return one line
sudo sed -i 's/2g/1g/g' /etc/default/puppetserver  # replace 1g memory usage 
sudo grep 1g /etc/default/puppetserver   # Check  
sudo systemctl start puppetserver  # start the service
sudo systemctl enable puppetserver # set symbolic link for starting up puppetserver when rebooting the VM
sudo systemctl status puppetserver  # check service status
```

## Set up the user 
```shell
sudo -s   # switch to root
vi .profile  # edit .profile
# Adding 
export PATH=$PATH:/opt/puppetlabs/bin:   # adding path to puppet program
# save 
source .profile   # set the shell session to get the latest changes
puppet --version  # get the puppet version
```

## adding a DNS entry
```shell
# set up puppet host with the internal IP address
vi /etc/hosts
# adding 
<internal ip_address> puppet  
# save 
ping puppet # Test ping
puppet agent -t  # Check if it's work fine
```

## Generate a CA on server
```shell
/opt/puppetlabs/bin/puppetserver ca list -a # list all current certificats

```

**Go to CONTAINERS.md**