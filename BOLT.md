# Usage of Bolt

Bolt is stand-alone configuration management agentless.    
We can use Puppet Bolt to deploy the agent or other pre-requisites stuff.   


## Configure target1 container using Portainer 
```shell
# go to target1 in portainer, open a console 
passwd
# enter password as a password for root container
vi /etc/ssh/sshd_config
# search for PermitRootLogin
# replace by 
PermitRootLogin yes
#save it 
sudo kill -SIGHUP $(pgrep -f "sshd -D") # kill sshd process using pgrep to find it
/usr/sbin/sshd -D
```
### Check on the vm
```shell
ssh root@<ip_target1_container>
#enter password as password
```


## Install Bolt and first command
```shell
# adding target1 ip in /etc/hosts
sudo apt install -y puppet-bolt
sudo -s
bolt command run whoami -t target1 -u root -p password --no-host-key-check
ssh-keygen -t rsa
# without a passphrase
ssh-copy-id roor@target1
bolt command run whoami -t target1 -u root
```



