### **Automatically Send Email Alerts When a Puppet Class Fails in Foreman**  

#### **Scenario:**  
We want to **send an email notification** whenever a Puppet class fails on a managed node in Foreman.

---

## **Step 1: Enable Email Notifications in Foreman**  
### **1. Configure Foreman Email Settings**  
Edit the Foreman email configuration file:  
```sh
sudo nano /etc/foreman/settings.yaml
```
Find and set the following parameters:  
```yaml
:email_delivery: :smtp
:smtp_address: "smtp.example.com"
:smtp_port: 587
:smtp_domain: "example.com"
:smtp_user_name: "alert@example.com"
:smtp_password: "yourpassword"
:smtp_authentication: :login
```
**Restart Foreman** to apply the changes:  
```sh
sudo systemctl restart foreman
```

---

## **Step 2: Create a Foreman Notification Hook for Puppet Failures**  
Foreman allows custom **notification hooks** when a Puppet report contains a failure.

### **1. Create a Custom Hook Script**
```sh
sudo mkdir -p /usr/share/foreman/config/hooks/report/processed/
sudo nano /usr/share/foreman/config/hooks/report/processed/email_alert.sh
```

### **2. Add the Following Script**
```bash
#!/bin/bash

HOSTNAME=$1
STATUS=$2

if [[ "$STATUS" == *"failed"* ]]; then
  echo "Puppet run failed on $HOSTNAME" | mail -s "Puppet Failure Alert: $HOSTNAME" alert@example.com
fi
```
Save the file and make it executable:  
```sh
sudo chmod +x /usr/share/foreman/config/hooks/report/processed/email_alert.sh
```

---

## **Step 3: Link the Hook to Puppet Reports**  
Edit `/etc/foreman-proxy/settings.d/puppet.yml` and ensure **Puppet report processing** is enabled:  
```yaml
:enabled: true
:puppetdir: /var/lib/puppet/reports
:puppetuser: puppet
```
Restart Foreman Proxy:  
```sh
sudo systemctl restart foreman-proxy
```

---

## **Step 4: Test the Email Notification**  
Manually trigger a Puppet failure:  
```sh
puppet agent --test --noop
```
If Foreman detects a failure, an email should be sent! 🎉  

---

## **Summary**
✅ **Configured Foreman email alerts**  
✅ **Set up a notification hook for Puppet failures**  
✅ **Automatically sends an email when a Puppet class fails**  

Would you like to log alerts to **Slack or a monitoring tool like Zabbix?** 🚀1
