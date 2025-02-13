## **Advanced PuppetDB Queries**  

PuppetDB allows you to write powerful queries to extract data from your Puppet infrastructure. These queries can be used for reporting, automation, and making dynamic decisions in Puppet manifests.

---

## **1. Query Basics: PQL (Puppet Query Language)**  
PuppetDB uses **PQL (Puppet Query Language)** to fetch data. You can query nodes, facts, reports, catalogs, and resources.

### **Example: List All Nodes**
```bash
puppet query 'nodes {}'
```
Output:
```json
[
  {
    "certname": "node1.example.com",
    "deactivated": null,
    "expired": null
  },
  {
    "certname": "node2.example.com",
    "deactivated": null,
    "expired": null
  }
]
```
This fetches all nodes managed by PuppetDB.

---

## **2. Querying Facts**  
Facts store detailed information about nodes, such as OS type, IP addresses, and kernel versions.

### **Example: Get All Facts for a Specific Node**
```bash
puppet query 'facts { certname="node1.example.com" }'
```
Output:
```json
[
  {
    "name": "os",
    "value": {
      "name": "Ubuntu",
      "release": {
        "major": "20",
        "minor": "04"
      }
    }
  },
  {
    "name": "ipaddress",
    "value": "192.168.1.100"
  }
]
```

### **Example: Find Nodes Running Ubuntu**
```bash
puppet query 'nodes { facts.os.name = "Ubuntu" }'
```

### **Example: Find Nodes with More Than 4 CPU Cores**
```bash
puppet query 'nodes { facts.processors.count > 4 }'
```

### **Example: Get the IP Addresses of All Nodes**
```bash
puppet query 'facts [certname, value] { name = "ipaddress" }'
```
Output:
```json
[
  { "certname": "node1.example.com", "value": "192.168.1.100" },
  { "certname": "node2.example.com", "value": "192.168.1.101" }
]
```

---

## **3. Querying Reports**  
You can fetch reports to check Puppet runs and errors.

### **Example: Get the Latest Report for a Node**
```bash
puppet query 'reports [certname, status, end_time] { certname="node1.example.com" order by end_time desc limit 1 }'
```

### **Example: Find Nodes That Had Failed Puppet Runs**
```bash
puppet query 'reports { status = "failed" }'
```

---

## **4. Querying Resources**  
PuppetDB can return information about managed resources.

### **Example: Find All Nodes That Have Apache Installed**
```bash
puppet query 'resources { type="Package" and title="apache2" and parameters.ensure="present" }'
```

### **Example: Find Nodes That Have a Specific File Managed**
```bash
puppet query 'resources { type="File" and title="/etc/motd" }'
```

---

## **5. Using PuppetDB Queries in Manifests**
You can use PuppetDB queries inside Puppet manifests using the `puppetdb_query` function.

### **Example: Apply a Policy Only to Nodes with a Specific OS**
```puppet
$ubuntu_nodes = puppetdb_query('nodes { facts.os.name = "Ubuntu" }')

if $facts['certname'] in $ubuntu_nodes {
  package { 'nginx':
    ensure => installed,
  }
}
```

---

## **Conclusion**
With PuppetDB queries, you can dynamically fetch node data, monitor infrastructure, and apply conditional logic in manifests. Do you want me to cover exporting query results to dashboards or integrating PuppetDB with external tools like Grafana? 🚀|I1-
