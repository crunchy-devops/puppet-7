# install on fedora
```shell
sudo dnf remove puppet7-release.noarch
sudo dnf autoremove -y
sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-fedora-30.noarch.rpm
sudo dnf install pdk
sudo rpm -Uvh https://yum.puppet.com/puppet-tools-release-fedora-34.noarch.rpm
sudo dnf install puppet-bolt
gem install r10k
sudo dnf remove puppet.noarch
sudo dnf autoremove -y
sudo dnf install http://yum.puppet.com/puppet-release-fedora-36.noarch.rpm
sudo yum install puppet-agent
sudo yum install puppetserver
puppet agent -t
/opt/puppetlabs/bin
/opt/puppetlabs/bin/puppet agent -t
cd /opt/puppetlabs/bin/
ll
/opt/puppetlabs/bin/facter osfamily

```