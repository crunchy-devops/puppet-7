# First manifests

## First manifest
Manifests allow us to save code into scripts with an extension of .pp  
Manifests can be applied locally with ```puppet apply```
For full automation manifests need to be stored on the server  
in the correct environment.  
The default environment is production.  
```shell
# binary is at /opt/puppetlabs/bin
puppet config print
puppet config print config
puppet config print manifest --section master --environment production 
vi /etc/puppetlabs/code/environments/production/manifests/site.pp
``` 

### Simple message 
Ajout un simple message 
```puppet
notify {'message':
  name => 'my message',
  message => 'Hello webforce 3 groupe',
}
```
All files are processed in alphabetical order
les commandes suivantes fournissent un resultat identique.

```shell
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
puppet agent -t
```

### Chaine de carateres avec simple quote et double quotes et variables
```puppet
notify {"FqdnTest":
  message => 'mon fqdn est ${::fqdn}', # With single-quote variables are not converted into value 
}
```
Avec des double-quotes

```puppet
notify {'FqdnTest':
  message => "mon fqdn est ${::fqdn}", # Top-level variable from facter resources
}
```
### Variable
```puppet

$todo = "Test"
notify {'Test':
  message => "la variable est = ${todo}", # display local variable 
}
```

### Idempotence 
Creer un user alice   
```shell
sudo useradd alice
```
et nous executons une autre fois la meme commande   
```shell
sudo useradd alice 
```
Nous avons un message        
Alors qu'avec une maniere declarative comme le langage DSL Puppet  

```puppet
user { 'paul': 
  ensure => 'present',
}
```
Executez le script une deuxieme fois, il n'y a pas de message.    
```puppet
user { 'mcfakey':
    ensure     => 'present',
    managehome => true,
}
```
Mettre une linmite temps pour les mots de passe
```puppet
user { 'fusco':
  ensure           => 'present',
  # ATTENTION utilisation de single quotes to arreter $ evaluation
  password         => '$6$LD5snipgNY1',
  password_max_age => 30,
}
```
Verification 
```shell
chage -l fusco 
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
go to MODULES.md  