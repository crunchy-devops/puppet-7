# Modules 
Extending manifests into modules  
Modules are great ways to encapsulate code in to reusable lumps.  
Puppet forge is a great resource for modules that have been shared.  
The stdlib from puppetlabs is always useful. 

```shell
puppet module list
puppet module install puppetlabs/<module_name>
# shared module directory across environments
puppet module install -i /etc/puppetlabs/code/modules puppetlabs/stdlib

```

## Edit module code 
```shell
cd /etc/puppetlabs/code/environments/production/modules/stdlib/examples/
cp file_line.pp ~
cd ~
puppet apply file_line.pp 
cat /tmp/dansfile
cat file_line.pp 
```
Remove the line in dansfile, add a line such as hello-world  

## BIG THREE
The 3 big resources are : 
1. Package
2. Service
3. File

## Create the module structure 
```shell
cd /etc/puppetlabs/code/environments/production/modules # change to the relevant directory
mkdir -p chrony/{manifests,files,examples} # modules directories needed
apt install tree # install package tree
tree chrony # for displaying the directory structure
```

## Read the init.pp code 
And give some explanations
```shell
grep -vE '^(#|$)' /etc/chrony/chrony.conf > /etc/puppetlabs/code/environments/production/modules/chrony/files/chrony.conf
```
Note: grep -v means find the lines which do not contains something.  
so with the E switch is regexp that means find line that do not begin with # or $  

## Use a module 
```shell
cd /etc/puppetlabs/code/environments/production/manifests
vi 01.pp
# add
include chrony
# quit
puppet agent -t # check 
```

## Condition 
```shell
vi 01.pp
# change
if $osfamily == 'RedHat'{
    include chrony
}
# quit
puppet agent -t # check
facter --show-legacy | grep osfamily
```

## How to increase fact limit
```shell
/opt/puppetlabs/bin/puppet module install puppetlabs-inifile --version 5.4.0
```
Create a site.pp file
```puppet

$conf_dir = $facts['os']['family'] ? {
      'windows' => "${facts['common_appdata']}/PuppetLabs/puppet/etc",
      default => '/etc/puppetlabs/puppet'
  }

  ini_setting { 'puppet agent: fact_value_length_soft_limit':
      ensure => present,
      path => "${conf_dir}/puppet.conf",
      section => 'agent',
      setting => 'fact_value_length_soft_limit',
     value => '8192'
  }
```

## Remove a module
```shell
puppet module list # display all modules installed
puppet module uninstall puppetlabs/apache # remove module
puppet module list # check 
```


go to FILE_LINE.md



