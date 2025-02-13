Here's an example setup where **Puppet Master (puppetmaster7)** manages two **Puppet Agents**, ensuring that user `bob`'s SSH key is propagated from one remote agent to another.

---

## **1. Puppet Master Setup (puppetmaster7)**
On the Puppet Master, create a manifest to sync `bob`'s SSH key from **Agent1** to **Agent2**.

### **Step 1: Define a Puppet Module**
On the Puppet Master, create a module to manage `bob`'s SSH key.

```sh
mkdir -p /etc/puppetlabs/code/environments/production/modules/ssh_key_sync/manifests
```

### **Step 2: Create a Manifest**
Create `/etc/puppetlabs/code/environments/production/modules/ssh_key_sync/manifests/init.pp`:

```puppet
class ssh_key_sync {
  
  # Define the source file location on Agent1
  $source_host = 'agent1.example.com'
  $source_file = "/home/bob/.ssh/id_rsa.pub"
  $destination_file = "/home/bob/.ssh/authorized_keys"

  # Fetch the SSH key from Agent1
  exec { 'fetch_ssh_key':
    command => "scp bob@${source_host}:${source_file} /tmp/bob_id_rsa.pub",
    creates => '/tmp/bob_id_rsa.pub',
    require => Package['openssh-client'],
  }

  # Ensure bob's .ssh directory exists
  file { '/home/bob/.ssh':
    ensure  => directory,
    owner   => 'bob',
    group   => 'bob',
    mode    => '0700',
  }

  # Deploy the SSH key to Agent2
  file { $destination_file:
    ensure  => present,
    source  => 'file:///tmp/bob_id_rsa.pub',
    owner   => 'bob',
    group   => 'bob',
    mode    => '0600',
    require => File['/home/bob/.ssh'],
  }
}

```

---

## **2. Assign the Class to Puppet Agents**
On the Puppet Master, create a **site manifest** `/etc/puppetlabs/code/environments/production/manifests/site.pp`:

```puppet
node 'agent1.example.com' {
  # Ensure bob has an SSH key
  exec { 'generate_ssh_key':
    command => 'sudo -u bob ssh-keygen -t rsa -b 2048 -N "" -f /home/bob/.ssh/id_rsa',
    creates => '/home/bob/.ssh/id_rsa',
  }
}

node 'agent2.example.com' {
  include ssh_key_sync
}
```

---

## **3. Set Up Puppet Agents (On Both Remote Hosts)**
On each Puppet Agent (Agent1 & Agent2):

### **Step 1: Install Puppet Agent**
```sh
apt update && apt install -y puppet-agent
```

### **Step 2: Configure Puppet**
Edit `/etc/puppetlabs/puppet/puppet.conf`:

```ini
[main]
server = puppetmaster7.example.com
certname = agent1.example.com  # Change for agent2.example.com on the second agent
```

### **Step 3: Start the Puppet Agent**
```sh
puppet agent --test --waitforcert 60
```

On the Puppet Master, sign the certificates:

```sh
puppetserver ca sign --all
```

Then restart the Puppet Agents:

```sh
puppet agent --test
```

---

## **4. Verification**
On **Agent2**, check that `bob`'s SSH key is now in `/home/bob/.ssh/authorized_keys`:

```sh
cat /home/bob/.ssh/authorized_keys
```

This ensures `bob` can SSH from Agent1 to Agent2 using the copied key.

---

Would you like a more automated approach using Hiera or Puppet Bolt?