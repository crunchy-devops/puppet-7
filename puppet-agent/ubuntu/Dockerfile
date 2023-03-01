FROM ubuntu:20.04

RUN apt-get update -y && \
    wget https://apt.puppetlabs.com/puppet7-release-focal.deb && \
    dpkg -i puppet7-release-focal.deb && \
    apt-get update -y && \
    apt-get install puppet-agent -y