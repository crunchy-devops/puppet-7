# install docker on Centos Stream 8

```shell
sudo -s
dnf -y remove podman runc 
curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf --enablerepo=docker-ce-stable -y install docker-ce
systemctl enable --now docker
rpm -q docker-ce
docker version
docker ps
```