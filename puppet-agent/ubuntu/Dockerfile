FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y wget vim  && \
    wget https://apt.puppetlabs.com/puppet7-release-focal.deb && \
    dpkg -i puppet7-release-focal.deb && \
    apt-get update -y && \
    apt-get install puppet-agent -y


CMD ["tail","-f","/dev/null"]
