# pull base image
FROM ubuntu:14.04

# Adapted from William Yeh's version: https://hub.docker.com/r/williamyeh/ansible/builds/bupsfaeea9nxfnqu7xaj3iy/
MAINTAINER Michael Sevilla

RUN echo "===> Adding Ansible's PPA..."  && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list           && \
    echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/ansible.list    && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367    && \
    DEBIAN_FRONTEND=noninteractive  apt-get update  && \
    \
    \
    echo "===> Installing experiment master stuff: ansible, wget, vim..."  && \
    apt-get install -y ansible  && \
    apt-get install -y wget && \
    apt-get install -y vim && \
    \
    echo "===> Removing Ansible PPA..."  && \
    rm -rf /var/lib/apt/lists/*  /etc/apt/sources.list.d/ansible.list  && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa


# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
