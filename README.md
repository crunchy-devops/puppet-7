# Puppet on Centos8

## Install centos stream 8 et puppet repo package
```shell
hostnamectl # Check your os
curl 'http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-3.el8.noarch.rpm' --output key.rpm # initialize repo
sudo rpm -i key.rpm 
sudo dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos
sudo yum -y update
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm # install extra packages repo
sudo yum -y update # register your new repo
sudo yum -y install htop  # install htop for checking your vm
htop  # Ctrl-c to get out 
sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm # install puppet repo package
sudo yum list  --disablerepo '*' --enablerepo=puppet7 available
yum list puppet*  # list all packages related to puppet
sudo yum install -y puppetserver # install puppetserver and puppet agent in  a same time
sudo repoquery --repoid=puppet7 | xargs yum list installed
```