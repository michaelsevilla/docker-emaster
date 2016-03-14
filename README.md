Launches an experiment master (i.e. emaster) container that lets the user orchestrate experiments. This experiment master is a container with Ansible, Docker, and various parsers/graphing utilities. It pulls the code for each system and pushes it to each slave node. When it pulls the code, it keeps it so that it can launch Docker containers that run the clients.

This should be used as part of the [infra](https://github.com/systemslab/infra) framework. Launching from the commandline doesn't give you all the features.

===================================================
Quickstart
===================================================

To launch an experiment master, execute:

```bash
docker run -dt \
    --name="emaster" \
    --net=host \
    --volume="/var/run/docker.sock:/var/run/docker.sock" \
    -e SSHD_PORT=2222 \
    -e AUTHORIZED_KEYS="`cat ~/.ssh/id_rsa.pub`" \
    --privileged \
    michaelsevilla/emaster
```

You can either SSH in or drop into the container

```bash
ssh -p 2222 root@localhost
docker exec -it emaster /bin/bash
```

EOF
