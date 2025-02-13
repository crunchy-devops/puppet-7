Using **Hiera**, we can cleanly separate configuration data from the Puppet code. Below is a structured way to propagate **bob's SSH key** from **Agent1** to **Agent2** using **Puppet Master (puppetmaster7)**.

---

## **1. Hiera Configuration on Puppet Master**
Ensure **Hiera** is set up by editing `/etc/puppetlabs/puppet/hiera.yaml`:

```yaml
---
version: 5
hierarchy:
  - name: "Per-node data"
    path: "nodes/%{::trusted.certname}.yaml"

  - name: "Common data"
    path: "common.yaml"
```

This tells Puppet to check `nodes/agent1.example.com.yaml` and `nodes/agent2.example.com.yaml` for per-node configurations.

---

## **2. Create Hiera Data Files**
### **Agent1 - SSH Key Source (nodes/agent1.example.com.yaml)**
On Puppet Master, create `/etc/puppetlabs/code/environments/production/data/nodes/agent1.example.com.yaml`:

```yaml
---
ssh_key::generate: true
ssh_key::user: "bob"
ssh_key::home: "/home/bob"
ssh_key::public_key_path: "/home/bob/.ssh/id_rsa.pub"
```

### **Agent2 - SSH Key Destination (nodes/agent2.example.com.yaml)**
Create `/etc/puppetlabs/code/environments/production/data/nodes/agent2.example.com.yaml`:

```yaml
---
ssh_key::deploy: true
ssh_key::user: "bob"
ssh_key::home: "/home/bob"
ssh_key::authorized_keys_path: "/home/bob/.ssh/authorized_keys"
ssh_key::source_host: "agent1.example.com"
```

---

## **3. Puppet Module for SSH Key Management**
Create a module called `ssh_key_sync`:

```sh
mkdir -p /etc/puppetlabs/code/environments/production/modules/ssh_key_sync/manifests
```

### **3.1 Manifest: ssh_key_sync/manifests/init.pp**
Create `/etc/puppetlabs/code/environments/production/modules/ssh_key_sync/manifests/init.pp`:

```puppet
class ssh_key_sync {
  if lookup('ssh_key::generate', Boolean, 'first', false) {
    exec { 'generate_ssh_key':
      command => "sudo -u ${lookup('ssh_key::user')} ssh-keygen -t rsa -b 2048 -N '' -f ${lookup('ssh_key::public_key_path')}",
      creates => lookup('ssh_key::public_key_path'),
    }
  }

  if lookup('ssh_key::deploy', Boolean, 'first', false) {
    $source_host = lookup('ssh_key::source_host')
    $source_file = lookup('ssh_key::public_key_path')
    $destination_file = lookup('ssh_key::authorized_keys_path')

    exec { 'fetch_ssh_key':
      command => "scp ${lookup('ssh_key::user')}@${source_host}:${source_file} ${destination_file}",
      require => Package['openssh-client'],
    }

    file { lookup('ssh_key::home'):
      ensure  => directory,
      owner   => lookup('ssh_key::user'),
      group   => lookup('ssh_key::user'),
      mode    => '0700',
    }

    file { $destination_file:
      ensure  => present,
      owner   => lookup('ssh_key::user'),
      group   => lookup('ssh_key::user'),
      mode    => '0600',
      require => File[lookup('ssh_key::home')],
    }
  }
}
```

---

## **4. Apply Module in site.pp**
Edit `/etc/puppetlabs/code/environments/production/manifests/site.pp`:

```puppet
node 'agent1.example.com' {
  include ssh_key_sync
}

node 'agent2.example.com' {
  include ssh_key_sync
}
```

---

## **5. Deploy & Run Puppet**
On **Puppet Master**, deploy the configurations:

```sh
puppet agent --test
```

Sign agent certificates:

```sh
puppetserver ca sign --all
```

Run the Puppet Agent on both **Agent1** and **Agent2**:

```sh
puppet agent --test
```

---

## **6. Verification**
On **Agent1**, confirm SSH key generation:

```sh
ls -l /home/bob/.ssh/id_rsa.pub
```

On **Agent2**, confirm key propagation:

```sh
cat /home/bob/.ssh/authorized_keys
```

Now, `bob` should be able to SSH from **Agent1** to **Agent2** without a password.

---

### **Summary of Hiera Benefits**
- Clean separation of **data** and **logic**.
- Easier **scalability**—add new agents without modifying the manifest.
- Centralized configuration in YAML files.

Would you like a **Bolt-based** alternative for real-time key synchronization?