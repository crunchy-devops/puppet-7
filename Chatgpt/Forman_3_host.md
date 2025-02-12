### **Installing Foreman with Puppet on 3 Remote Hosts (1 Foreman + 2 Puppet Clients)**  

#### **Scenario:**  
We will set up **Foreman** on one host (`foreman.example.com`) and configure **two remote Puppet agent nodes** (`node1.example.com` & `node2.example.com`).  

### **1. Setup: Define Hosts**
| Hostname               | Role               | IP Address Example  |
|------------------------|--------------------|---------------------|
| **foreman.example.com** | Foreman + Puppet Master | 192.168.1.10 |
| **node1.example.com**   | Puppet Agent       | 192.168.1.11 |
| **node2.example.com**   | Puppet Agent       | 192.168.1.12 |

---

## **1. Install Foreman on the Puppet Master Node**
### **On `foreman.example.com`:**
#### **Step 1: Install Foreman + Puppet**
```sh
sudo yum install -y epel-release
sudo yum install -y https://yum.theforeman.org/releases/3.5/el7/x86_64/foreman-release.rpm
sudo yum install -y foreman-installer
```

#### **Step 2: Run Foreman Installer**
```sh
sudo foreman-installer --enable-foreman-proxy \
  --foreman-proxy-puppet true \
  --foreman-proxy-puppetca true
```
👉 This will install and configure Foreman with Puppet.

#### **Step 3: Verify Installation**
```sh
systemctl status foreman foreman-proxy
```

#### **Step 4: Get Foreman Admin Password**
```sh
cat /etc/foreman-installer/scenarios.d/foreman-answers.yaml | grep password
```
Now, **login to Foreman UI** at:  
👉 `http://foreman.example.com` (default admin credentials)

---

## **2. Configure Puppet on Remote Agents**
### **On `node1.example.com` and `node2.example.com`:**
#### **Step 1: Install Puppet Agent**
```sh
sudo yum install -y https://yum.puppet.com/puppet-release-el-7.noarch.rpm
sudo yum install -y puppet-agent
```

#### **Step 2: Configure Puppet Agent**
Edit `/etc/puppetlabs/puppet/puppet.conf`:  
```ini
[main]
server = foreman.example.com
report = true
pluginsync = true
```

#### **Step 3: Start Puppet Agent**
```sh
sudo systemctl enable --now puppet
puppet agent -t
```

#### **Step 4: Approve Agent Requests on Foreman**
On **Foreman UI** → **Infrastructure** → **Smart Proxies** → **Puppet CA**  
Approve **node1.example.com** and **node2.example.com**.

Now, agents are fully connected to Foreman! 🎉

---

## **3. Deploy Configuration with Foreman**
### **Example: Install Nginx on `node1.example.com` & `node2.example.com`**
1. **Go to Foreman UI** → **Configure** → **Classes**
2. Search for `nginx` and assign it to `node1` & `node2`
3. Run Puppet on agents:
```sh
puppet agent -t
```
Now, **Nginx is installed automatically** on both nodes! 🎉

---

## **Summary**
✅ **Foreman installed on `foreman.example.com`**  
✅ **Two Puppet agents (`node1`, `node2`) registered**  
✅ **Configuration applied via Foreman**  

Would you like to **extend this to auto-provision VMs using Foreman PXE boot?** 🚀
