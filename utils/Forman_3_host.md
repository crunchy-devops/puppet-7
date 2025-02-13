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

---

### **Install Foreman with Puppet 7 on 3 Hosts (Web, DB, Monitoring) with AlmaLinux, Ubuntu, and Alpine**  

#### **Scenario:**  
We will set up **Foreman** as the Puppet master, managing **3 remote hosts** with different OS types:  

| **Hostname**          | **Role**        | **OS**       | **IP Address (Example)**  |
|-----------------------|----------------|--------------|---------------------------|
| **foreman.example.com** | Foreman + Puppet Server | AlmaLinux 9 | 192.168.1.10 |
| **web.example.com**  | Web Server (Nginx) | Ubuntu 22.04 | 192.168.1.11 |
| **db.example.com**   | Database Server (PostgreSQL) | Alpine Linux | 192.168.1.12 |
| **monitor.example.com** | Monitoring (Zabbix) | AlmaLinux 9 | 192.168.1.13 |

---

## **Step 1: Install Foreman & Puppet 7 on AlmaLinux (Master)**
### **On `foreman.example.com` (AlmaLinux 9)**
1️⃣ **Install Foreman Repository**
```sh
sudo dnf install -y epel-release
sudo dnf install -y https://yum.theforeman.org/releases/3.5/el9/x86_64/foreman-release.rpm
sudo dnf install -y foreman-installer
```

2️⃣ **Run the Foreman Installer**
```sh
sudo foreman-installer --enable-foreman-proxy \
  --foreman-proxy-puppet true \
  --foreman-proxy-puppetca true
```
👉 This sets up **Foreman as the Puppet master**.

3️⃣ **Check Foreman Status**
```sh
systemctl status foreman foreman-proxy
```

4️⃣ **Get Foreman Admin Password**
```sh
grep password /etc/foreman-installer/scenarios.d/foreman-answers.yaml
```
👉 **Login to Foreman Web UI** at `http://foreman.example.com`

---

## **Step 2: Install Puppet Agents on Remote Hosts**
### **On `web.example.com` (Ubuntu 22.04)**
1️⃣ **Install Puppet 7 Agent**
```sh
wget https://apt.puppet.com/puppet7-release-jammy.deb
sudo dpkg -i puppet7-release-jammy.deb
sudo apt update
sudo apt install -y puppet-agent
```

2️⃣ **Configure Puppet to Connect to Foreman**
```sh
echo -e "[main]\nserver=foreman.example.com\nreport=true\npluginsync=true" | sudo tee /etc/puppetlabs/puppet/puppet.conf
```

3️⃣ **Start Puppet Agent**
```sh
sudo systemctl enable --now puppet
puppet agent -t
```

---

### **On `db.example.com` (Alpine Linux)**
1️⃣ **Install Puppet 7 on Alpine**
```sh
apk add puppet
```

2️⃣ **Configure Puppet**
```sh
echo -e "[main]\nserver=foreman.example.com\nreport=true\npluginsync=true" > /etc/puppetlabs/puppet/puppet.conf
```

3️⃣ **Start Puppet**
```sh
puppet agent -t
```

---

### **On `monitor.example.com` (AlmaLinux 9)**
1️⃣ **Install Puppet Agent**
```sh
sudo dnf install -y https://yum.puppet.com/puppet7-release-el-9.noarch.rpm
sudo dnf install -y puppet-agent
```

2️⃣ **Configure Puppet**
```sh
echo -e "[main]\nserver=foreman.example.com\nreport=true\npluginsync=true" | sudo tee /etc/puppetlabs/puppet/puppet.conf
```

3️⃣ **Start Puppet Agent**
```sh
sudo systemctl enable --now puppet
puppet agent -t
```

---

## **Step 3: Approve Puppet Agents in Foreman**
On **Foreman UI** → **Infrastructure** → **Smart Proxies** → **Puppet CA**  
Approve:
✅ `web.example.com`  
✅ `db.example.com`  
✅ `monitor.example.com`  

Now, all nodes are registered with Foreman! 🎉

---

## **Step 4: Assign Puppet Modules in Foreman**
### **Web Server (`web.example.com` - Ubuntu)**
Assign `nginx` class:
```puppet
class { 'nginx':
  ensure => installed,
}
```

### **Database Server (`db.example.com` - Alpine)**
Assign `postgresql` class:
```puppet
class { 'postgresql::server':
  ensure => present,
}
```

### **Monitoring Server (`monitor.example.com` - AlmaLinux)**
Assign `zabbix` class:
```puppet
class { 'zabbix::server':
  ensure => running,
}
```

Now, run **Puppet on each node**:
```sh
puppet agent -t
```
All services will be **installed automatically**! 🚀

---

## **Summary**
✅ **Foreman installed on AlmaLinux**  
✅ **Puppet agents configured on Ubuntu, Alpine, and AlmaLinux**  
✅ **Puppet modules applied dynamically via Foreman**  

Would you like to extend this to **auto-provisioning VMs using Foreman PXE boot?** 🚀
