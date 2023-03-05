# Puppet on Ubuntu

## Gateway host

```shell
# ssh to gateway host provided 
sh connect.sh
# check the prompt
```

## Install 
```shell
sudo apt-get update -y
wget https://apt.puppetlabs.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt-get update -y
sudo apt-get install puppetserver -y
sudo vi /etc/default/puppetserver
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
sudo systemctl status puppetserver
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
# set up puppet host with the intenal IP address
vi /etc/hosts
# adding 
10.132.0.10 puppet 
# save 
ping puppet
puppet agent -t  # Check if it's work fine
```

Go to CONTAINERS.md