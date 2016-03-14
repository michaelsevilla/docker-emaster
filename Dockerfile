FROM tutum/ubuntu:trusty

MAINTAINER Michael Sevilla <mikesevilla3@gmail.com>

RUN echo "===> Install the basics..." && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -yq --force-yes \ 
      apt-transport-https vim wget software-properties-common curl lynx openssh-client openssh-server

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
      docker-engine=1.7.1-0~trusty \
      python-dev \
      python-setuptools\
      python-pip \
      openjdk-7-jre && \
    easy_install pip && \
    pip install docker-py && \
    sudo apt-get clean && sudo rm -rf \
      /var/lib/apt/lists/* /etc/apt/sources.list.d/ansible.list \
      tmp/* /var/tmp/* && \
    apt-get purge lxc-docker*

RUN echo "===> Getting graph utilities..."  && \
    wget https://github.com/adamcrume/TailPlot/releases/download/v1.4.0/tailplot-1.4.0-jar-with-dependencies.jar && \
    echo "java -Dsun.java2d.opengl=true -jar /tailplot-1.4.0-jar-with-dependencies.jar \"\$@\"" >> /bin/tailplot && \
    chmod 750 /bin/tailplot

RUN echo "===> Adding hosts for convenience..."  && \
    echo '[local]\nlocalhost\n' > /etc/ansible/hosts && \
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

RUN echo "===> Customize the prompt..."  && \
    mkdir /root/callbacks && \
    echo "export PS1=[EXPERIMENT_MASTER]\ " >> /root/.bashrc

# for docker
EXPOSE 2375

# * modify sshd conf
# * workaround for the way ubuntu deals with env for sudo
# * add /ceph to PATH
# * create expected dirs/links
RUN sed -i "s/UsePAM.*/UsePAM yes/" /etc/ssh/sshd_config && \
    echo "PATH=/ceph/src:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/ceph/bin" > /etc/environment && \
    echo "alias sudo='sudo env PATH=\$PATH'" >> /etc/environment && \
    sed -i "s/Defaults.*env_reset//" /etc/sudoers && \
    sed -i "s/Defaults.*secure_path.*//" /etc/sudoers

# override tutom's run.sh with our own
ADD .ansible.cfg /root/.ansible.cfg
ADD separate_play.py /root/callbacks/separate_play.py

ENV PATH /bin/:$PATH
ENV ANSIBLE_LIBRARY /infra/modules:$ANSIBLE_LIBRARY

ADD emaster-shell /bin/emaster-shell
RUN chmod 750 /bin/emaster-shell
ENTRYPOINT ["bin/emaster-shell"]
