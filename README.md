srg52x-docker
===

SRG-3352x docker container for developement applications

1. to install docker.io, please reference [this article](https://docs.docker.com/engine/install/ubuntu). And to add your account into docker group and launch docker

    > sudo usermod -aG docker <your account>
    >
    > \# reminds: you can reboot the host or
    >
    > \# try the below commands for launch docker service
    >
    > sudo systemctl enable docker
    >
    > sudo systemctl start docker


2. install qemu-user-static 

    > a. apt update
    >
    > b. apt install qemu-user-static binfmt-support binfmt-misc
    >
    > c. update-binfmts --enable qemu-arm

3. clone this repository on your local development host

    > git clone https://github.com/aaeon-kunyi/srg52x-docker.git

4. build the docker image

    > cd srg52x-docker
    >
    > ./build_container.sh # the step will build a docker image on local host and create ./works folder for place your source code

5. run the docker image for your application development, 

    > ./run_container.sh  # the step will start a container
