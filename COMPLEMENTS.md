# More stuff

## BIG THREE
The 3 big resources are :
1. Package
2. Service
3. File

## Installer le module chrony
Creez un projet sous github nomme puppet-modules, avec un readme.md, .gitignore sous ruby, licence MIT  
Faire un git clone en local, ouvrir ce projet dans rubymine  
Vous avez 2 projets ouverts: puppet-7 et puppet-modules  
Dans puppet-7, selectionnez la directory chrony, faire Ctrl-C  
Dans puppet-modules, selectionnez le nom du projet en caracteres gras en haut de la fenetre projet     
et faire un Ctrl-V, validez    

## Retrouver la version d'OS dans votre VM puppetmaster
```facter --show-legacy | grep osfamily```

## Get the file chrony.conf
```shell
grep -vE '^(#|$)' /etc/chrony/chrony.conf 
```
Note: grep -v means find the lines which do not contains something.  
so with the E switch is regexp that means find line that do not begin with # or $
Creez un fichier dans votre projet git hub puppet-modules
Copy the result in chrony->file fichier  

## site.pp 
Dans le projet puppet-modules. Creez un directory manifests 
creez un fichier site.pp
```shell
vi site.pp
# adding
if $osfamily == 'version_d'os trouve'{
  include chrony
}
```

## environment.conf
Dans le projet puppet-modules. directement sous le projet 
Creez le fichier environement.conf
```shell
## add these lines
modulepath = site::modules::$basemodulepath
manifest = manifests/site.pp
```

## Etudiez les fichiers de chrony

## git commit, git push

## Modifier r10k 
Allez dans /etc/puppetlabs/r10k   
et modifier r10k.yaml
```yaml
---
:sources:
  :control:
    remote: 'votre gihub account'
    basedir: '/etc/puppetlabs/code/environments'
    prefix: false
```
## Deployment avec r10k
```shell
ll /etc/puppetlabs/code/environments
rm -Rf <directory>
r10k deploy environment
```

## Check the module structure on the puppetmaster
```shell
apt install tree # install package tree
tree /etc/puppetlabs/code -d # for displaying the directory structure
```

## Test 
```puppet agent -t --environment main```

# TEMPLATE EPP
## Read the init.pp code 
And give some explanations
```shell
grep -vE '^(#|$)' /etc/chrony/chrony.conf > /etc/puppetlabs/code/environments/production/modules/chrony/files/chrony.conf
```
Note: grep -v means find the lines which do not contains something.  
so with the E switch is regexp that means find line that do not begin with # or $

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

## EPP example with chrony
```shell

## Change file chrony.epp
```puppet
<% if $timezone == 'BST' { -%>
pool uk.pool.ntp.org iburst
<% } elsif $timezone == 'GMT' { -%>
pool uk.pool.ntp.org iburst
<% } else { -%>
pool us.pool.ntp.org iburst
<% } -%>
...
```
Make some tests by changing  the timezone
```shell
timedatectl set-timezone America/Denver
```

## Change the manifest accordingly
```shell
cd ../manifests  # change to manifests directory
vi init.pp  # edit file
# change line to 
content => epp('chrony/chrony.epp'),
```

## Tests
```shell
cat /etc/chrony.conf
puppet agent -t
cat /etc/chrony.conf