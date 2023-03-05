FROM quay.io/centos/centos

RUN  curl 'http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-3.el8.noarch.rpm' --output key.rpm  && \
     rpm -i key.rpm  && \
     dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos && \
     yum -y update && \
     dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
     yum -y update && \
     rpm -Uvh https://yum.puppet.com/puppet7-release-el-8.noarch.rpm && \
     yum list  --disablerepo '*' --enablerepo=puppet7 && \
     yum install -y puppet-agent

CMD ["tail","-f","/dev/null"]
