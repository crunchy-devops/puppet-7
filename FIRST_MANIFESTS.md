# First manifests

## Manifest
Manifests allow us to save code into scripts with an extension of .pp  
Manifests can be applied locally with ```puppet apply```
For full automation manifests need to be stored on the server  
in the correct environment.  
The default environment is production.

```shell
puppet config print
puppet config print config
puppet config print manifest --section master --environment production 
vi /etc/puppet/code/environments/production/manifests/site.pp
``` 

### Simple message 
Display a simple message 
```puppet
notify {'message':
  name => 'my message',
  message => 'Hello nobleprog group',
}
```
All files are processed in alphabetical order
```shell
puppet apply /etc/puppet/code/environments/production/manifests/site.pp
puppet agent -t
```

### String with simple  quote and  double quotes variables
```puppet
notify {"FqdnTest":
  message => 'mon fqdn est ${::fqdn}', # With single-quote variables are not converted into value 
}
```
with double-quotes

```puppet
notify {'FqdnTest':
  message => "mon fqdn est ${::fqdn}", # Top-level variable from facter resources
}
```
Facter is a tool that returns all internal values of the host into puppet variables 
```shell
facter processors
facter processors.isa
facter --json os.name os.release.major processors.isa
```

### Variable
```puppet

$todo = "Test"
notify {'Test':
  message => "value is = ${todo}", # display local variable 
}
```
#### Variable Types
$redis_package_name = 'redis'   # String  
$install_java = true            # Boolean  
$dns_servers = [ '8.8.8.8' , '8.8.4.4' ]   # Array  
$config_hash = { user => 'joe', group => 'admin' }  # Hash  

### Idempotence 
Create a user   
```shell
sudo useradd alice
```
if we execute again this command   
```shell
sudo useradd alice 
```
We get a warning message       
In other hand a declarative command such as Puppet DSL Language  
the script always works even the user is already there
```puppet
user { 'alice': 
  ensure => 'present',
}
```

```puppet
user { 'mcfakey':
    ensure     => 'present',
    managehome => true,
}
```

### Puppet resource

Put a time limit for password
```puppet
user { 'fusco':
  ensure           => 'present',
  # Bewarwe of singles-quotes 
  password         => '$6$LD5snipgNY1',
  password_max_age => 30,
}
```
# check
```shell
chage -l fusco 
```

```puppet
# create a directory
  file { '/tmp/site-conf':
    ensure => 'directory',
  }

  # a fuller example, including permissions and ownership
  file { '/tmp/admin-app-log':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

```
Symbolic link 
```puppet
file { '/tmp/link-to-motd':
    ensure => link,
    target => '/etc/motd',
  }
```

Add a file , but failed to update it if it has been changed manually ( replace no)
```puppet
file { '/tmp/hello-file':
  ensure  => file,
  replace => 'no', # a well-known switch 
  content => "From Puppet\n",
  mode    => '0644',
}
```

###  Install apache module
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

## Exercise 1

Créez un fichier site.pp qui me permet de créer un dossier /tmp/test sur mes deux containers

go to FILE_LINE.md

