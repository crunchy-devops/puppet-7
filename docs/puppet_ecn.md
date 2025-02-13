Here’s an example of a **Puppet External Node Classifier (ENC)** that assigns roles to 10 remote hosts, grouped into:

- **3 Database hosts** (`role::db`)
- **5 Web hosts** (`role::web`)
- **2 Monitoring hosts** (`role::monitoring`)

### Example ENC Script (Outputs YAML)
If you're using a script-based ENC, you can create something like this:

#### `/etc/puppetlabs/puppet/enc.rb`
```ruby
#!/usr/bin/env ruby
# Puppet ENC script

require 'yaml'

# Define node roles
node_roles = {
  'db1.example.com'  => 'role::db',
  'db2.example.com'  => 'role::db',
  'db3.example.com'  => 'role::db',
  
  'web1.example.com' => 'role::web',
  'web2.example.com' => 'role::web',
  'web3.example.com' => 'role::web',
  'web4.example.com' => 'role::web',
  'web5.example.com' => 'role::web',

  'mon1.example.com' => 'role::monitoring',
  'mon2.example.com' => 'role::monitoring'
}

# Get hostname from Puppet
hostname = ARGV[0]

# Output YAML for Puppet
enc_output = {
  'classes' => [node_roles[hostname] || 'role::default'],
  'parameters' => {
    'environment' => 'production'
  }
}

puts enc_output.to_yaml
```
Make the script executable:
```sh
chmod +x /etc/puppetlabs/puppet/enc.rb
```
And configure Puppet to use this ENC:
```ini
[main]
node_terminus = exec
external_nodes = /etc/puppetlabs/puppet/enc.rb
```

---

### Alternative: Node Classification in Puppet `site.pp`
If you don’t want to use an ENC script, you can classify nodes in `site.pp`:

#### `/etc/puppetlabs/code/environments/production/manifests/site.pp`
```puppet
node /^db\d+\.example\.com$/ {
  include role::db
}

node /^web\d+\.example\.com$/ {
  include role::web
}

node /^mon\d+\.example\.com$/ {
  include role::monitoring
}

node default {
  notify { "This node is not classified.": }
}
```

---

### Hiera-Based Classification (Optional)
If you're using Hiera, define node-specific data:

#### `/etc/puppetlabs/code/environments/production/data/nodes/db1.example.com.yaml`
```yaml
---
classes:
  - role::db
```

#### `/etc/puppetlabs/code/environments/production/data/nodes/web1.example.com.yaml`
```yaml
---
classes:
  - role::web
```

#### `/etc/puppetlabs/code/environments/production/data/nodes/mon1.example.com.yaml`
```yaml
---
classes:
  - role::monitoring
```

---

Would you like help defining the `role::db`, `role::web`, and `role::monitoring` Puppet classes?