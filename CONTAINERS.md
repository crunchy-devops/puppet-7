# Containers


## Ubuntu container
```shell
cd puppet-agent/ubuntu  # go to the relevant directory
docker build -t puppet-agent-ubuntu .  # build the image
docker run -d --name target1 --add-host puppet:<internal_ip> puppet-agent-ubuntu # enter puppetmaster internal ip address 
docker exec -it target1 /bin/bash # go inside the container
cat /etc/hosts # check
puppet agent -t  # check 
```

## Centos 8 Stream  
```shell
cd puppet-agent/centos-8-stream  # go to the relevant directory
docker build -t puppet-agent-centos .  # build the image
docker run -d --name target2 --add-host puppet:<internal_ip> puppet-agent-centos # enter puppetmaster internal ip address 
docker exec -it target2 /bin/bash # go inside the container
cat /etc/hosts # check
puppet agent -t  # check 
```