# Create Environments
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