# External Node Classifier (ENC)
This ENC script is designed to use a YAML inventory for looking up node classification. It is written in a way that allows
environments to be defined with classes, class parameters, and general parameters used as top-scope variables.
A separate nodes hash in the inventory is used to assign nodes to a defined environment. 
The nodes hash also permits individual nodes to have classes and parameters assigned. Node and environment data 
from the inventory will be merged, with node data taking precedent inthe event of a conflict.

If a node is not defined in the 'nodes' hash of the inventory file, it simply defaults to the 'production' environment. 
To assign a different environment to a node, 
define the node in the 'nodes' hash with the syntax: <node>: <environment>.
To assign an environment with additional custom settings specific to the node, define the node entry as a has and use
the syntax environment: <environment> in the node data. 
The example inventory demonstrates both techniques:

```shell
cp enc.rb /etc/puppetlabs/puppet/
chown root:puppet /etc/puppetlabs/puppet/enc.rb
chmod 750 /etc/puppetlabs/puppet/enc.rb
touch /etc/puppetlabs/puppet/inventory.yaml
chmod 640 /etc/puppetlabs/puppet/inventory.yaml
```

## Set up manually 
```shell
[master]
node_terminus = exec
external_nodes = /etc/puppetlabs/puppet/enc.rb
```

## Set up programmatically
```shell
puppet config set --section master node_terminus exec
puppet config set --section master external_nodes /etc/puppetlabs/puppet/enc.rb
```

# Test
With the ENC script and inventory in place, you can sanity check the 
inventory file by executing the ENC script with the name of the node 
you want to test. This returns the ENC node
data in YAML format in the same way it will be seen by the Puppet server.

```./enc.rb production```