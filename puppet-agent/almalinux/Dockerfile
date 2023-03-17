FROM almalinux


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

RUN dnf -y update && \
    dnf -y install epel-release && \
    dnf -y install supervisor openssh-server openssh-clients htop passwd && \
    dnf install -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y puppet-agent

RUN  ssh-keygen -t rsa -q -f "/etc/ssh/ssh_host_rsa_key"      -N "" && \
     ssh-keygen -t rsa -q -f "/etc/ssh/ssh_host_dsa_key"      -N "" && \
     ssh-keygen -t rsa -q -f "/etc/ssh/ssh_host_ecdsa_key"    -N "" && \
     ssh-keygen -t rsa -q -f "/etc/ssh/ssh_host_ed25519_key"  -N ""

ADD files/supervisord.conf /root

CMD ["/usr/bin/supervisord", "-c", "/root/supervisord.conf"]