Launches an interactive bash session that lets the user orchestrate experiments. This experiment master is a container with Ansible and Docker. It pulls the code for each system and pushes it to each slave node. When it pulls the code, it keeps it so that it can launch Docker containers that run the clients.

===================================================
Quickstart
===================================================

To start launch an experiment master, execute:

    docker run -it \
        --name="emaster" \
        --net=host \
        --volume="$(dirname `pwd`):/infra/" \
        --volume="/tmp/:/tmp/" \
        --volume="/etc/ceph:/etc/ceph" \
        --workdir="/infra/experiments" \
        --volume="/var/run/docker.sock:/var/run/docker.sock" \
        --privileged \
        michaelsevilla/emaster \
        /bin/bash

