FROM ubuntu:trusty

MAINTAINER Michael Sevilla

RUN echo "===> Install the basics..." && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
      apt-transport-https vim wget software-properties-common

RUN echo "===> Adding Ansible's PPA..."  && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee /etc/apt/sources.list.d/ansible.list           && \
    echo "deb-src http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/ansible.list    && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367

RUN echo "===> Adding Docker's PPA..." && \
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee -a /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

RUN echo "===> Adding LTTnG PPA..." && \
    apt-add-repository -y ppa:lttng/ppa
    
RUN echo "===> Installing experiment master stuff..."  && \
    apt-cache policy docker-engine && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -yq --force-yes \ 
      ansible \
      docker-engine \
      python-dev \
      python-setuptools\
      python-pip \
      lttng-tools \
      liblttng-ust-dev \
      python3-pip \
      python3-babeltrace \
      openjdk-7-jre && \
    easy_install pip && pip3 install numpy && \
    sudo apt-get clean && sudo rm -rf \
      /var/lib/apt/lists/* /etc/apt/sources.list.d/ansible.list \
      tmp/* /var/tmp/* && \
    apt-get purge lxc-docker*

RUN echo "===> Getting graph utilities..."  && \
    wget https://github.com/adamcrume/TailPlot/releases/download/v1.4.0/tailplot-1.4.0-jar-with-dependencies.jar

RUN echo "===> Adding hosts for convenience..."  && \
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

# for docker
EXPOSE 2375
