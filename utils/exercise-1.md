Here's an **advanced Puppet 8 exercise** for **IT students** focused on **installing and configuring software** using Puppet. This exercise will cover:

✅ **Installing Apache (or any software)**  
✅ **Managing configuration files**  
✅ **Using Puppet classes and parameters**  
✅ **Applying manifests with `puppet apply`**

---

# **🎯 Exercise: Install and Configure Apache using Puppet 8**

## **📌 Objective**
Create a **Puppet module** that:
1. Installs **Apache HTTP Server** (`httpd` on RHEL, `apache2` on Debian).
2. Ensures the service is running.
3. Manages the configuration file `/etc/httpd/conf/httpd.conf` (or `/etc/apache2/apache2.conf`).
4. Deploys a **custom index.html** file to `/var/www/html/index.html`.

---

## **📂 1️⃣ Create a Puppet Module**
Run:
```bash
pdk new module apache_install
cd apache_install
```

---

## **📝 2️⃣ Create the Main Class**
Edit `manifests/init.pp`:
```puppet
class apache_install (
  String $package_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  },
  String $config_file = $facts['os']['family'] ? {
    'RedHat' => '/etc/httpd/conf/httpd.conf',
    'Debian' => '/etc/apache2/apache2.conf',
    default  => '/etc/httpd/conf/httpd.conf',
  },
  String $service_name = $facts['os']['family'] ? {
    'RedHat' => 'httpd',
    'Debian' => 'apache2',
    default  => 'httpd',
  }
) {
  package { $package_name:
    ensure => installed,
  }

  service { $service_name:
    ensure    => running,
    enable    => true,
    require   => Package[$package_name],
  }

  file { $config_file:
    ensure  => present,
    content => template('apache_install/httpd.conf.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  file { '/var/www/html/index.html':
    ensure  => present,
    content => template('apache_install/index.html.erb'),
    require => Package[$package_name],
  }
}
```

---

## **📜 3️⃣ Create Templates for Configuration**
### **🔹 Apache Config Template (`templates/httpd.conf.erb`)**
```erb
ServerRoot "/etc/httpd"
Listen 80
ServerAdmin webmaster@localhost
DocumentRoot "/var/www/html"
<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```

### **🔹 Web Page Template (`templates/index.html.erb`)**
```erb
<!DOCTYPE html>
<html>
<head>
    <title>Puppet Apache Install</title>
</head>
<body>
    <h1>Apache Installed with Puppet 8!</h1>
    <p>This page was deployed using Puppet templates.</p>
</body>
</html>
```

---

## **🖥 4️⃣ Apply the Puppet Manifest**
Run:
```bash
puppet apply --modulepath=./modules -e 'include apache_install'
```

---

# **💡 Expected Outcome**
✔ Apache is installed and running.  
✔ `/etc/httpd/conf/httpd.conf` is configured.  
✔ `/var/www/html/index.html` is deployed.

---

# **📌 Additional Challenges**
🔹 Modify Apache to listen on **port 8080** instead of 80.  
🔹 Add support for **multiple virtual hosts**.  
🔹 Use **Hiera** to separate config data from the module.

---

This **hands-on exercise** helps IT students practice **real-world Puppet automation**! 