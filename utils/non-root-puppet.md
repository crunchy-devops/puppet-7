To set up the **Puppet manifest directory** for a **non-root user**, follow these steps:

---

## **1️⃣ Create a Non-Root User for Puppet**
Create a user (e.g., `puppetdev`) and add it to a group:
```bash
sudo useradd -m -s /bin/bash puppetdev
sudo groupadd puppetgroup
sudo usermod -aG puppetgroup puppetdev
```

---

## **2️⃣ Set Up the Puppet Directory with Correct Permissions**
### **🔹 Move the Puppet Manifest Directory**
By default, Puppet uses `/etc/puppetlabs/code` for manifests. Move it to a non-root directory:
```bash
sudo mv /etc/puppetlabs/code /home/puppetdev/puppet-code
```

### **🔹 Change Ownership to Non-Root User**
Give `puppetdev` ownership:
```bash
sudo chown -R puppetdev:puppetgroup /home/puppetdev/puppet-code
sudo chmod -R 770 /home/puppetdev/puppet-code
```

---

## **3️⃣ Update Puppet Configuration**
Modify `/etc/puppetlabs/puppet/puppet.conf`:
```ini
[main]
    environmentpath = /home/puppetdev/puppet-code/environments
    basemodulepath = /home/puppetdev/puppet-code/modules
    hiera_config = /home/puppetdev/puppet-code/hiera.yaml
```
Restart Puppet to apply changes:
```bash
sudo systemctl restart puppet
```

---

## **4️⃣ Configure SELinux (if enabled)**
If using SELinux, allow Puppet to access the new directory:
```bash
sudo semanage fcontext -a -t puppet_var_lib_t "/home/puppetdev/puppet-code(/.*)?"
sudo restorecon -Rv /home/puppetdev/puppet-code
```

---

## **5️⃣ Run Puppet as Non-Root User**
Switch to the user:
```bash
su - puppetdev
```
Apply manifests:
```bash
puppet apply --environment=development --noop /home/puppetdev/puppet-code/environments/development/manifests/site.pp
```

---

## **🎯 Final Setup**
✅ **Non-root user `puppetdev`**  
✅ **Custom directory `/home/puppetdev/puppet-code`**  
✅ **Updated `puppet.conf`**  
✅ **Permissions configured**

