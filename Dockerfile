FROM ubuntu:trusty

# adapted from William Yeh's version: https://hub.docker.com/r/williamyeh/ansible/builds/bupsfaeea9nxfnqu7xaj3iy/
# adapted from Ivo Jimenez's version: https://hub.docker.com/r/ivotron/teuthology/
MAINTAINER Michael Sevilla

RUN echo "===> Adding Ansible's PPA..."  && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list           && \
    echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/ansible.list    && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367

ENV CEPH_VERSION hammer
RUN echo "===> Install ceph version ${CEPH_VERSION}" && \
    echo deb http://download.ceph.com/debian-${CEPH_VERSION}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list

RUN echo "===> Installing experiment master stuff..."  && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -yq --force-yes \
        ceph ansible wget vim git \
        python-dev python-pip python-virtualenv python-libvirt \
        libevent-dev libssl-dev libmysqlclient-dev libffi-dev && \
    sudo apt-get clean && sudo rm -rf \
        /var/lib/apt/lists/* /etc/apt/sources.list.d/ansible.list \
        tmp/* /var/tmp/*

RUN echo "===> Adding hosts for convenience..."  && \
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

ADD ./teuthology /teuthology
RUN echo "===> Setup teuthology..." && \
    cd /teuthology  && ./bootstrap
ENV PATH "$PATH:/teuthology/virtualenv/bin"

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
CMD [ "teuthology", "--version" ]
