Launches an interactive bash session that lets the user orechestrate experiments. This experiment master is a container with Ansible and Teuthology. 

===================================================
Quickstart
===================================================

To start launch an experiment master, execute:

    docker run -it \
    --name="emaster" \
    --hostname="experiment_master" \
    michaelsevilla/emaster \
    /bin/bash

