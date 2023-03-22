# Usage of file_line

The aim of the exercice is to change the line PermitRoot yes to 
PermitRoot no 

## Example on sshd configuration 
```shell
grep PermitRoot /etc/ssh/sshd_config
# we get 2 lines 
grep ^PermitRoot /etc/ssh/sshd_config
sshd -T | grep permitroot
```

## Build your code 
Check if ssh is installed  
```shell
puppet resource package openssh > ssh.pp # copy relevant code to ssh.pp
vi ssh.pp
# remove version number in set installed
# remove the provider in the last line 
puppet resource service sshd >> ssh.pp
vi ssh.pp
# remove the provider in the last line 
## add require 
require => Package['openssh'],
```
## Add file_line 
```shell
vi ssh.pp
```
add the following code 
```puppet
file_line { 'ssh_root_login' :
  path   => '/etc/ssh/sshd_config',
  ensure => file,
  line   => 'PermitRootLogin no',
  match  => '^PermitRootLogin ',
  notify => Service['sshd'],
  
}
```
```shell
sshd -T | grep permitroot  # check 
puppet apply ssh.pp
sshd -T | grep permitroot # check
mv ssh.pp
```

## More with file_line resource 

### Add a string -- type reference
```puppet
file { '/tmp/eureka.txt':
ensure => file,
}->
file_line { 'Append a line to /tmp/eureka.txt':
path => '/tmp/eureka.txt',  
line => 'Hello World',
}
```

```shell
file { '/tmp/eureka.txt':
ensure => file,
backup => '.bck',
}->
file_line { 'Append a line to /tmp/eureka.txt':
path => '/tmp/eureka.txt',  
line => 'Hello Eureka',
match   => "^Hello.*$",

}
```

### Absent is more complex than present 
```shell
# copy sshd_config in tmp
mkdir -p /tmp/etc/ssh/
cp /etc/ssh/sshd_config  /tmp/etc/ssh/
```

Create a stdlib.pp file
```shell
file_line { 'no_port':
  ensure => absent,
  match  => '^Port',
  line => 'Port 5432',
  path   => '/tmp/etc/ssh/sshd_config',
  match_for_absence => true,
  multiple =>true, 
}
```

## Other example
using a fact variable 
Creez un fichier httpd.conf
```shell
<VirtualHost *:80>
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{SERVER_NAME}/$1 [R,L]
</VirtualHost>
```
Creez un fichier fact_replace.pp
```puppet
include stdlib
$domaine = $facts['fqdn']
file_line { 'virtual_host':
  ensure => present,
  path   => '/tmp/etc/ssh/httpd.conf',
  line   => "<VirtualHost ${domaine}:80>",
  match  => '<VirtualHost \*:80>',
}
```

Go to TEMPLATES.md