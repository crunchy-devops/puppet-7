### **Concrete Example: Using Foreman in a Puppet Environment**  

#### **Scenario:**  
You have a Puppet-managed infrastructure with **10 nodes** and want to:  
✅ **Provision hosts** using Foreman  
✅ **Manage configuration** (e.g., install Apache on web servers)  
✅ **Monitor and enforce compliance**  

---

## **1. Install and Configure Foreman with Puppet Integration**  

On the Foreman server, install Foreman and configure Puppet:  
```sh
foreman-installer --enable-foreman-proxy \
                  --foreman-proxy-puppet true \
                  --foreman-proxy-puppetca true \
                  --foreman-proxy-tftp true \
                  --foreman-proxy-dhcp true \
                  --foreman-proxy-dns true \
                  --foreman-proxy-logs true
```

### **Verify Services**
Ensure Foreman services are running:  
```sh
systemctl status foreman foreman-proxy
```

---

## **2. Configure Puppet Agents to Report to Foreman**  

On **each Puppet agent (nodes)**, configure the Puppet agent to use Foreman:  

```sh
puppet agent --test --server=<foreman-server>
```

Update Puppet configuration on **each node** (`/etc/puppetlabs/puppet/puppet.conf`):  
```ini
[main]
server = <foreman-server>
report = true
pluginsync = true
```

Restart the Puppet agent:  
```sh
systemctl restart puppet
```

Now, nodes will **automatically report** to Foreman.

---

## **3. Define a Puppet Environment in Foreman**  

Create a **Puppet environment** (e.g., `production`) inside Foreman:  
1. **Go to Foreman UI → Configure → Environments**  
2. **Add environment** → Name: `production`  

On the Foreman server, ensure Puppet recognizes this environment:  
```sh
mkdir -p /etc/puppetlabs/code/environments/production/manifests
```

---

## **4. Assign Puppet Classes to Hosts via Foreman**  

### **Example: Install Apache on Web Servers**  
1. **Go to Foreman UI → Configure → Classes**  
2. Search for `apache` (ensure the Puppet module is installed)  
3. **Assign `apache` class to Web servers**  

#### **Puppet Manifest (`apache.pp`)**
```puppet
class apache {
  package { 'apache2':
    ensure => installed,
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => Package['apache2'],
  }
}
```
Apply the Puppet configuration on the nodes:  
```sh
puppet agent -t
```
Now, **Apache is installed and managed via Foreman!** 🚀

---

## **5. Monitor and Enforce Compliance**  

In Foreman, navigate to:  
- **Reports** → View Puppet runs  
- **Hosts** → Check compliance status  

If a host drifts from its intended state, Foreman will trigger **automatic remediation**.

---

## **Summary**  
✅ **Foreman manages and provisions Puppet nodes**  
✅ **Nodes report to Foreman for compliance and auditing**  
✅ **Configuration is applied dynamically via Foreman UI**  

Would you like to see **automatic provisioning with PXE boot**? 🚀1
