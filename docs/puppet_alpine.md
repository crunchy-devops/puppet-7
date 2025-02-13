To install the Puppet Agent on an **Alpine-based Docker container**, follow these steps:

### **1. Start an Alpine Container**
```sh
docker run -it --name puppet-agent alpine sh
```

### **2. Update Packages & Install Dependencies**
Alpine uses `apk` as its package manager. Install the necessary dependencies:
```sh
apk add --no-cache bash curl
```

### **3. Download & Install Puppet Agent**
The Puppet Agent is not officially supported on Alpine, but you can try using the RPM package via `rpm` compatibility:

#### **Option 1: Using RPM Compatibility (Not Officially Supported)**
```sh
apk add --no-cache rpm
curl -O https://yum.puppet.com/puppet-release-el-7.noarch.rpm
rpm -i puppet-release-el-7.noarch.rpm
apk add --no-cache puppet-agent
```

#### **Option 2: Using a Precompiled Puppet Agent (If Available)**
You might need to manually compile Puppet for Alpine or use a community-provided package:
```sh
curl -O https://apt.puppet.com/puppet7-release-bullseye.deb
apk add --no-cache dpkg
dpkg -i puppet7-release-bullseye.deb
apk add --no-cache puppet-agent
```

### **4. Verify Installation**
```sh
puppet --version
```

### **5. Start the Puppet Agent**
```sh
/opt/puppetlabs/bin/puppet agent --test
```

### **Alternative: Using a Puppet Docker Image**
Instead of installing manually, you can use a prebuilt Puppet agent image:
```sh
docker run -it --rm puppet/puppet-agent:latest /bin/bash
```

Would you like a custom Dockerfile to automate this?