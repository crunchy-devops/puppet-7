# Create Environments

```shell
mkdir -p /etc/puppetlabs/code/environments/dev/manifests # create a dev environment
ll /etc/puppetlabs/code/environments/  # Check 
#puppet config set environment production --section=agent  # assign dev environment in puppet configuration
```

## Agent run
By default every 30 minutes
```shell
puppet config print runinterval  # returns 1800 seconds
expr 1800 / 60 
puppet agent -t
```
## Change runinterval 
```puppet
puppet config set runinterval 120 # check modification on the puppetmaster every 2 minutes
cat /etc/puppetlabs/puppet/puppet.conf # Check the modification in the config file 
sudo kill -SIGHUP $(pgrep -f "puppet") # Restart Puppet agent  
```




## Bash Alias
```shell
alias cdpp='cd $(puppet config print manifest)'
```

## Resource
```shell
puppet resource --type # list of resource available 
puppet describe service  # service display
puppet resource service httpd # service httpd

```

go to R10K.md