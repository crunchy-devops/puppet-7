### **Installing and Configuring Foreman in a Puppet Environment**  

Foreman is a powerful **lifecycle management tool** for Puppet, used for provisioning, configuration management, and monitoring. Below is a structured **Puppet setup** to install **Foreman** in a managed environment.

---

## **1. Set Up Puppet and Foreman Repository**  
### **Add Foreman Repository Using Puppet**
Create a Puppet manifest file named `foreman.pp`:

```puppet
class foreman {
  # Install required dependencies
  package { ['wget', 'ca-certificates']:
    ensure => installed,
  }

  # Add the Foreman repository
  exec { 'add_foreman_repo':
    command => 'wget -q https://deb.theforeman.org/foreman-release-buster.deb && dpkg -i foreman-release-buster.deb',
    unless  => 'test -f /etc/apt/sources.list.d/foreman.list',
  }

  # Update package list
  exec { 'update_apt':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    require     => Exec['add_foreman_repo'],
  }

  # Install Foreman
  package { 'foreman-installer':
    ensure  => installed,
    require => Exec['update_apt'],
  }

  # Run the Foreman installer
  exec { 'install_foreman':
    command => 'foreman-installer',
    unless  => 'test -f /etc/foreman-installer/scenarios.d/foreman-answers.yaml',
    require => Package['foreman-installer'],
  }
}
```

---

## **2. Apply the Manifest**  
Save the file as `foreman.pp` and apply it using:  

```sh
puppet apply foreman.pp
```

---

## **3. Verify Foreman Installation**  
After installation, check the Foreman service:  

```sh
systemctl status foreman
```
👉 You should see **active (running)** if Foreman is correctly installed.  

### **Access the Foreman Web UI**
- Open your browser and navigate to:  
  ```
  http://<your_foreman_server>:3000
  ```
- Default credentials:  
  ```
  Username: admin  
  Password: (found in /etc/foreman-installer/scenarios.d/foreman-answers.yaml)
  ```

---

## **4. Configure Puppet with Foreman**
Once Foreman is installed, integrate it with Puppet:

### **Install Foreman-Puppet Plugin**
```sh
foreman-installer --enable-foreman-plugin-puppet
```

### **Configure Puppet Agent to Use Foreman**
On your Puppet agents, run:
```sh
puppet agent --test --server=<your_foreman_server>
```

---

## **Summary**
✅ **Installs Foreman using Puppet**  
✅ **Sets up Foreman repository & dependencies**  
✅ **Runs `foreman-installer` for automation**  
✅ **Integrates Foreman with Puppet for centralized control**  

Would you like to add **automatic provisioning for hosts**? 🚀
