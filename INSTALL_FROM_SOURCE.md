# Install from source

## Install puppetserver
```shell
sudo apt -y update
sudo apt -y install ruby
sudo apt -y install gem
sudo snap install openjdk
git clone --recursive https://github.com/puppetlabs/puppetserver.git
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
sudo mv lein /usr/local/bin/lein
cd puppetserver/
./dev-setup
find / -name puppetserver.conf  2>/dev/null
sudo lein run -c /home/hme/puppetserver/dev/puppetserver.conf
```
