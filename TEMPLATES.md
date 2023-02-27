# Templates EPP
Embedded Puppet (EPP) is a templating language based on the Puppet language. You can use EPP   
in Puppet 4 and higher, and with Puppet 3.5 through 3.8 with the future parser enabled.   
Puppet evaluates EPP templates with the epp and inline_epp functions.  

## Creating a Simple EPP template for the MOTD file 
```shell
vi motd.epp
#add 
This is the system:
<%= $facts['ipaddress'] %> <%= $facts['fqdn'] %>
:wq 
```
## Test 
```shell
puppet epp render motd.epp
```

```shell
mkdir /etc/puppetlabs/code/environments/production/modules/chrony/templates
mv /etc/puppetlabs/code/environments/production/modules/chrony/files/chrony.conf \
   /etc/puppetlabs/code/environments/production/modules/chrony/templates/chrony.epp
```
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
```
go to PDK.md 