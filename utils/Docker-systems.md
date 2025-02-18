Simulating a **systemd** service inside a **Docker container** requires special handling since Docker containers do not run a full **init system** by default. Below is a guide with a **Dockerfile example**.

---

## **1. Using systemd in a Docker Container**  
To properly run **systemd** inside a Docker container, you need:  
- A base image with `systemd` installed (e.g., `ubuntu`, `centos`, `rockylinux`).  
- Set `init` as PID 1 or manually run `systemd`.  
- Privileged mode (`--privileged`) or mounting `cgroup`.  

---

## **2. Example: Running systemd in an Ubuntu Container**  

### **Dockerfile (Ubuntu-based)**
```dockerfile
FROM ubuntu:20.04

# Install systemd and some basic utilities
RUN apt-get update && \
    apt-get install -y systemd systemd-sysv dbus && \
    apt-get clean

# Ensure systemd runs properly inside Docker
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
```

### **Build and Run the Container**
```bash
docker build -t systemd-ubuntu .
docker run --privileged -d --name test-systemd systemd-ubuntu
docker exec -it test-systemd bash
```

Now, you can check if **systemd** is running:
```bash
systemctl list-units --type=service --state=running
```

---

## **3. Example: Running a Custom Systemd Service in a Container**  
### **Create a Custom Systemd Service**  
Inside the container, create a new service file:  
```bash
sudo nano /etc/systemd/system/myapp.service
```

Add the following:
```ini
[Unit]
Description=My Sample Systemd Service
After=network.target

[Service]
ExecStart=/usr/bin/sleep infinity
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

Enable and start the service:
```bash
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp
systemctl status myapp
```

---

## **4. Running the Container with systemd Automatically**
Modify the Dockerfile to **include the systemd service**:

```dockerfile
FROM ubuntu:20.04

# Install systemd and utilities
RUN apt-get update && \
    apt-get install -y systemd systemd-sysv dbus && \
    apt-get clean

# Add a custom systemd service
RUN echo "[Unit]\nDescription=My Sample Service\nAfter=network.target\n\n[Service]\nExecStart=/usr/bin/sleep infinity\nRestart=always\nUser=root\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/myapp.service

# Enable the custom service
RUN systemctl enable myapp.service

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
```

### **Build and Run**
```bash
docker build -t systemd-service .
docker run --privileged -d --name test-systemd-service systemd-service
docker exec -it test-systemd-service bash
systemctl status myapp
```

---

## **5. Alternative Without Privileged Mode**
Instead of using `--privileged`, you canbind-mount cgroups manually:
```bash
docker run -d --name test-systemd \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --tmpfs /run --tmpfs /run/lock \
  systemd-service
```

---

## **Conclusion**
✅ **Dockerfile** runs `systemd` inside a container  
✅ Custom **systemd services** start automatically  
✅ Use `--privileged` or manually mount `/sys/fs/cgroup`  

Would you like an example with **CentOS/Rocky Linux** or integrating **Puppet** inside this container? 🚀
