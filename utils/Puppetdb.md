### Installing PuppetDB and Using It in a Real Example  

PuppetDB is a powerful database that stores structured data from Puppet. It allows you to query node configurations and
facts efficiently. Here’s how to install and use PuppetDB in a practical scenario.

---

## **Step 1: Install PuppetDB**
PuppetDB requires a PostgreSQL database. First, install PostgreSQL and PuppetDB.

### **1. Install PostgreSQL**
```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```
Create a PuppetDB user and database in PostgreSQL:
```bash
sudo -u postgres psql
```
Inside the PostgreSQL shell, run:
```sql
CREATE USER puppetdb WITH PASSWORD 'puppetdbpassword';
CREATE DATABASE puppetdb OWNER puppetdb;
GRANT ALL PRIVILEGES ON DATABASE puppetdb TO puppetdb;
\q
```
Modify PostgreSQL settings to allow PuppetDB to connect:
```bash
sudo nano /etc/postgresql/12/main/pg_hba.conf
```
Add the following line:
```
host    puppetdb    puppetdb    127.0.0.1/32    md5
```
Restart PostgreSQL:
```bash
sudo systemctl restart postgresql
```

---

### **2. Install PuppetDB**
On the Puppet server, install PuppetDB:
```bash
wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo apt update
sudo apt install -y puppetdb puppetdb-terminus
```

Configure PuppetDB to use PostgreSQL:
```bash
sudo nano /etc/puppetlabs/puppetdb/conf.d/database.ini
```
Modify the contents:
```ini
[database]
classname = org.postgresql.Driver
subprotocol = postgresql
subname = //127.0.0.1:5432/puppetdb
username = puppetdb
password = puppetdbpassword
```

Start PuppetDB:
```bash
sudo systemctl enable --now puppetdb
```

---

## **Step 2: Connect PuppetDB to the Puppet Server**
Modify Puppet’s `puppet.conf`:
```bash
sudo nano /etc/puppetlabs/puppet/puppet.conf
```
Add:
```ini
[master]
storeconfigs = true
storeconfigs_backend = puppetdb
```

Configure the PuppetDB terminus:
```bash
sudo nano /etc/puppetlabs/puppetdb/puppetdb.conf
```
Ensure it contains:
```ini
[main]
server_urls = https://puppetdb:8081
```

Restart the Puppet server:
```bash
sudo systemctl restart puppetserver
```

---

## **Step 3: Verify PuppetDB is Working**
Run:
```bash
puppet query 'nodes {}'
```
You should see a list of nodes.

---

## **Step 4: Real-World Example – Querying Node Facts**
Now let’s use PuppetDB to query facts from a node.

Run on the Puppet master:
```bash
puppet facts find agent-node.example.com
```
Expected output:
```json
{
  "name": "agent-node.example.com",
  "values": {
    "os": {
      "name": "Ubuntu",
      "release": {
        "major": "20",
        "minor": "04"
      },
      "family": "Debian"
    },
    "ipaddress": "192.168.1.100",
    "fqdn": "agent-node.example.com"
  }
}
```

You can use this data in your Puppet manifests. Example:
```puppet
if $facts['os']['name'] == 'Ubuntu' {
  package { 'apache2':
    ensure => installed,
  }
}
```

---

## **Conclusion**
Now you have a working PuppetDB setup integrated with a Puppet server. You can query node facts and use them in Puppet manifests to make dynamic infrastructure decisions.

---
### **🔹 Installing PuppetDB & PostgreSQL Using a Puppet Forge Module**

This setup uses **Puppet Forge modules** to install and configure:  
✅ **PuppetDB**  
✅ **PostgreSQL**  
✅ **Database connectivity between them**

---

## **1️⃣ Required Modules**
We will use:
- [`puppetlabs/puppetdb`](https://forge.puppet.com/modules/puppetlabs/puppetdb) → Installs PuppetDB
- [`puppetlabs/postgresql`](https://forge.puppet.com/modules/puppetlabs/postgresql) → Installs PostgreSQL

### **Install Required Modules**
Run on the Puppet Master:
```bash
puppet module install puppetlabs/puppetdb
puppet module install puppetlabs/postgresql
```

---

## **2️⃣ Create the Puppet Manifest**
Save this as **`site.pp`** (or apply it in a profile class).

```puppet
class { 'postgresql::server':
  ensure           => present,
  listen_addresses => 'localhost',
  manage_firewall  => false,
}

# Create PuppetDB Database & User in PostgreSQL
postgresql::server::db { 'puppetdb':
  user     => 'puppetdb',
  password => postgresql::postgresql_password('puppetdb', 'puppetdb_secure_password'),
  grant    => 'ALL',
}

class { 'puppetdb':
  listen_address => '0.0.0.0',
  database_host  => 'localhost',
  database_name  => 'puppetdb',
  database_user  => 'puppetdb',
  database_password => 'puppetdb_secure_password',
}

class { 'puppetdb::master::config':
  puppetdb_server => 'localhost',
  puppetdb_port   => 8081,
}

# Ensure PuppetDB service is running
service { 'puppetdb':
  ensure => running,
  enable => true,
  require => Class['puppetdb'],
}
```

---

## **3️⃣ Configure PuppetDB Database Connection**
Edit PuppetDB config file **`/etc/puppetlabs/puppetdb/conf.d/database.ini`**:
```ini
[database]
classname = org.postgresql.Driver
subprotocol = postgresql
subname = //localhost:5432/puppetdb
username = puppetdb
password = puppetdb_secure_password
```

Restart PuppetDB to apply changes:
```bash
systemctl restart puppetdb
```

---

## **4️⃣ Verify Installation**
### **Check PuppetDB Status**
```bash
systemctl status puppetdb
```
or
```bash
puppet query nodes
```

### **Check PostgreSQL Database**
```bash
sudo -u postgres psql -c '\l'
```
Ensure `puppetdb` is listed.

### **Test PuppetDB API**
```bash
curl -k https://localhost:8081/pdb/meta/v1/version
```
Expected output:
```json
{"version":"8.x.x"}
```

---

## **🎯 Summary**
✅ Installed PostgreSQL  
✅ Installed PuppetDB  
✅ Configured database connection  
✅ Verified installation


