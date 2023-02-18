# First manifests

## Install apache 
```shell
puppet module install puppetlabs/apache 
```

![Forge_apache](screenshot/forge_apache.png)

## Execute the module 
```shell
puppet apply -e 'include apache' # install apache
ss -nltp  # Check the port 80
curl localhost # Check the contents
```
Open your browser, enter your IP address as url  

## First manifest
Manifests allow us to save code into scripts with an extension of .pp  
Manifests can be applied locally with ```puppet apply```
For full automation manifests need to be stored on the server  
in the correct environment.  
The default environment is production.  
```shell
puppet config print
puppet config print config
puppet config print manifest --section master --environment production 
vi /etc/puppetlabs/code/environments/production/manifests/site.pp
``` 
All files are processed in alphabetical order     
both following commands are identical    
```shell
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
puppet agent -t
```

## Create Environments
```shell
mkdir -p /etc/puppetlabs/code/environments/dev/manifests # create a dev environment
ll /etc/puppetlabs/code/environments/  # Check 
puppet config set environment dev --section=agent  # assign dev environment in puppet configuration
```

## Agent run    
By default every 30 minutes  
```shell
puppet config print runinterval  # returns 1800 seconds
expr 1800 / 60 
puppet agent -t
```

## Bash Alias
```shell
alias cdpp='cd $(puppet config print manifest)'
puppet config print runinterval
```

## Resource 
```shell
puppet resource --type # list of resource available 
puppet describe service 
puppet resource service httpd 

```
