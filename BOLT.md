# Usage of Bolt

Bolt is stand-alone configuration management agentless.    
We can use Puppet Bolt to deploy the agent.    

## Install Bolt and first command
```shell
yum install -y puppet-bolt
bolt command run whoami -t node1 -u centos -p 12345678 --no-host-key-check
ssh-keygen
# without a passphrase
ssh-copy-id centos@node1
bolt command run whoami -t node1 -u centos
```



