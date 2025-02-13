# Install Docker on ubuntu using Ansible

## Prerequisite for ubuntu
```shell
# as normal user
cd
sudo apt update   # update all packages repo
#sudo apt upgrade  #  upgrade all packages
sudo apt -y install git wget          # install git and wget 
sudo apt -y install htop iotop iftop  # added monitoring tools
sudo apt-get -y install python3 python3-venv # install python3 and virtualenv
sudo apt-get -y install build-essential   # need for installing docker-compose
sudo apt-get -y install python3-dev libxml2-dev libxslt-dev libffi-dev # need for installing docker-compose
htop  # check your vm config
Crtl-c  # exit
``` 
## Install docker Community-Edition
```shell script
# install with python venv
```shell
sudo apt update
sudo apt -y install python3-venv
cd puppet-7
python3 -m venv venv
source venv/bin/activate
pip3 install wheel
pip3 install ansible
pip3 install setuptools
ansible-playbook -i inventory install_docker_ubuntu.yml
```
Log out from your ssh session and log in again so all changes will take effect.  
Type ``` docker ps``` as ubuntu user for checking if all is fine. 

## Portainer 
```shell
### Portainer
docker volume create portainer_data
docker run -d -p 32125:8000 -p 32126:9443 --name portainer --restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer-ce:latest
```

Go to CONTAINERS.md




