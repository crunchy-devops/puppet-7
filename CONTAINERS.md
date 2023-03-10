# Containers


## Portainer
```shell
docker run -d --name portainer -p 30001:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer -H unix:///var/run/docker.sock
```

## Ubuntu container
```shell
#as your normal user
cd 
cd puppet-7
cd puppet-agent/ubuntu  # go to the relevant directory
docker build -t puppet-agent-ubuntu .  # build the image
docker run -d --name target1 --add-host puppet:<internal_ip> puppet-agent-ubuntu # enter puppetmaster internal ip address 
# Check /etc/hosts using portainer
puppet agent -t  # check 
```

## Centos 8 Stream  
```shell
cd puppet-agent/centos-8-stream  # go to the relevant directory
docker build -t puppet-agent-centos .  # build the image
docker run -d --name target2 --add-host puppet:<internal_ip> puppet-agent-centos # enter puppetmaster internal ip address 
# Check /etc/hosts using Portainer
puppet agent -t  # check 
```

## Signed all certificates
As root outside containers, on your VM
```shell
/opt/puppetlabs/bin/puppetserver ca sign -a # list all current certificats
```

**Go to FIRST_MANIFESTS.md**