#!/bin/bash -e

GID=$(id -g)
USER_ID=$(id -u)
SHELL=/bin/bash
export GID
export USER_ID
export SHELL
MOUNT_DIR=$(pwd)/works
docker run --rm -i -t -v ${MOUNT_DIR}:/home/aaeon/works:rw \
    -e USER_ID=${UID} -e GROUP_ID=${GID} -e TERM=xterm -e SHELL=${SHELL} \
    -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e no_proxy=$no_proxy \
    --privileged --device=/dev/net/tun:/dev/net/tun \
    --cap-add=NET_ADMIN \
    srg52x-app-dev
#docker run --rm -i --privileged -e USER_ID=1000 -e GROUP_ID=1000 -e TERM=xterm -e SHELL=/bin/bash --rm -t -i srg52x-app-dev
 
