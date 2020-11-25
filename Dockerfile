
ARG IMAGE_ARCH=linux/arm/v7
ARG IMAGE_TAG=buster-20201117-slim

FROM --platform=$IMAGE_ARCH debian:$IMAGE_TAG AS base

LABEL aaeon-srg52x.architecture="armv7hf"

COPY qemu-arm-static /usr/bin

USER root

ENV USER aaeon
ENV PASS aaeon
ENV HOME /home/aaeon

# setting proxy for apt
RUN bash -c 'if test -n "$http_proxy"; then\
               echo "Acquire::http::proxy\"$http_proxy\";"\
                > /etc/apt/apt.conf.d/99proxy; \
             fi'

RUN apt update && apt-get install -y --no-install-recommends \
  sudo \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  cmake \
  libgpiod2 \
  libgpiod-dev \
  findutils \
  gnupg \
  dirmngr \
  inetutils-ping \
  netbase \
  curl \
  udev \
  procps \
  libmodbus-dev \
  libmodbus5 \ 
  libmosquitto-dev \
  libmosquitto1 \
  libgpiod2 \
  libgpiod-dev \
  python3 \
  python3-pip \
  vim \
  locales \
  git-core \
  wget \
  $( \
      if apt-cache show 'iproute' 2>/dev/null | grep -q '^Version:'; then \
        echo 'iproute'; \
      else \
        echo 'iproute2'; \
      fi \
  ) \
  && rm -rf /var/lib/apt/lists/* \
  && c_rehash \
  && echo '#!/bin/sh\n\
set -e\n\
set -u\n\
export DEBIAN_FRONTEND=noninteractive\n\
n=0\n\
max=2\n\
until [ $n -gt $max ]; do\n\
  set +e\n\
  (\n\
    apt-get update -qq &&\n\
    apt-get install -y --no-install-recommends "$@"\n\
  )\n\
  CODE=$?\n\
  set -e\n\
  if [ $CODE -eq 0 ]; then\n\
    break\n\
  fi\n\
  if [ $n -eq $max ]; then\n\
    exit $CODE\n\
  fi\n\
  echo "apt failed, retrying"\n\
  n=$(($n + 1))\n\
done\n\
rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*' > /usr/sbin/install_packages \
  && chmod 0755 "/usr/sbin/install_packages"

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV UDEV off

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG SHELL=/bin/bash
ARG WORK_DIR=/home/aaeon/works

RUN groupadd --gid $GROUP_ID $USER && useradd -s $SHELL --gid $GROUP_ID --uid $USER_ID --create-home $USER && usermod -a -G sudo $USER
RUN echo "$USER:$PASS" | chpasswd && echo "%$USER  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/aaeongrp
RUN chmod 0440 /etc/sudoers.d/aaeongrp

ADD gitproxy /usr/bin
RUN chmod +x /usr/bin/gitproxy
RUN bash -c 'if test -n "$http_proxy"; then\
               sed -i -e "s#\(http_proxy=\"\).*#\1$http_proxy\"#"/usr/bin/gitproxy;\
             fi'

# change user
USER $USER
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# setting git proxy if need
RUN bash -c 'if test -n "$http_proxy"; then\
              git config --global http.proxy "$http_proxy";\
              git config --global core.gitproxy gitproxy;\
             fi'

RUN bash -c 'if test -n "$https_proxy"; then\
              git config --global https.proxy "$https_proxy";\
             fi'

RUN bash -c 'if test -n "$no_proxy"; then\
              git config --global core.noproxy "$no_proxy";\
             fi'

WORKDIR $WORK_DIR

