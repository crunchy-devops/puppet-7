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
  ensure => 'present',
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
