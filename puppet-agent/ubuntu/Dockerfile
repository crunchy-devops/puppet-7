FROM ubuntu:20.04

# Setup environment
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update \
 && apt-get install -y vim.tiny wget sudo net-tools ca-certificates unzip \
 && rm -rf /var/lib/apt/lists/*


RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
# @url http://docs.docker.com/v1.6/examples/running_ssh_service/
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

# Add .bash_aliases on build
ONBUILD ADD files/.bash_aliases /root/.bash_aliases
# Add authorized SSH key on build
ONBUILD ADD files/authorized_keys /tmp/authorized_keys
ONBUILD RUN mkdir /root/.ssh; cat /tmp/authorized_keys > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys; rm -f /tmp/authorized_keys
# Regenerate host SSH keys on build
ONBUILD RUN dpkg-reconfigure openssh-server

RUN apt-get update -y && \
    apt-get install -y wget vim  openssh-server supervisor && \
    wget https://apt.puppetlabs.com/puppet7-release-focal.deb && \
    dpkg -i puppet7-release-focal.deb && \
    apt-get update -y && \
    apt-get install puppet-agent -y

ADD files/supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]

