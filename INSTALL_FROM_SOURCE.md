# Install Puppet eco-system from source

## Install latest version of puppetserver
```shell
sudo -s
apt -y update   # update package
apt -y install ruby  # install ruby
apt -y install gem  # install ruby gem
apt -y install openjdk-17-jre-headless 
git clone --recursive https://github.com/puppetlabs/puppetserver.git  # lastest version of puppet server
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein # clojure library used by puppetserver
chmod +x lein # made lein script executable 
mv lein /usr/local/bin/lein  # move lein script in comman directory 
cd puppetserver/  # change directory
./dev-setup  # build application 
find / -name puppetserver.conf  2>/dev/null  # find path of puppetserver.conf
lein run -c <find_value>  # start pupperserver 
ss -ntlp  # check port number 8140
```

## install latest version of puppet-agent
```shell
sudo -su
apt -y install bundler
git clone
vanagon build bolt-runtime ubuntu-22.04-amd64 target1
```

