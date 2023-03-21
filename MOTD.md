# The MOTD 

## Install PDK
```shell
sudo apt install -y pdk  # from package
# or 
sudo apt install y ruby # from package
gem install pdk  # install from ruby package manager gem . might the latest version od pdk
```
## Install your module 
Creez un projet sous github nomme puppet-motd, avec un readme.md, .gitignore sous ruby, licence MIT  
Faire un git clone dans votre VM dans la home directory
```shell
cd puppet-motd
pdk new module --skip-interview motd   # module motd created
cd motd
pdk new class motd 
```

## How to use .gitkeep  
```shell
find . -name .git -prune -o -type d -empty -exec touch {}/.gitkeep \; # create .gitkeep file inside empty directory
```

## Configure r10k
```
mkdir -p /etc/puppetlabs/r10k 
cd /etc/puppetlabs/r10k
vi r10k.yaml
```

### Added yaml configuration file
```yaml
---
:sources:
  :control:
    remote: 'https://github.com/crunchy-devops/puppet-motd.git'
    basedir: '/etc/puppetlabs/code/environments'
    prefix: false
```

###  Usage
```shell
cd /etc/puppetlabs/code/environments
r10k deploy environment
ll
# on a node
puppet agent -t --environment main
# set puppet config to main
puppet config set environment main --section=agent
```
