#!/bin/bash -e

GID=$(id -g)
USER_ID=$(id -u)
SHELL=/bin/bash

EXEC_QEMU=$(which qemu-arm-static)
if [ ! -f qemu-arm-static ]; then
  cp -vf ${EXEC_QEMU} .
fi

export USER_ID
export SHELL
export GID
mkdir -p works
docker build --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GID} --build-arg SHELL=$SHELL \
	--build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy \
       	--rm -t srg52x-app-dev .

