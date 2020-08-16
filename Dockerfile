FROM node:10.13-slim

### Install watchman build dependencies
RUN \
  apt-get update -y &&\
  apt-get install -y \
  autoconf \
  automake \
  build-essential \
  git \
  libssl-dev \
  libtool \
  pkg-config \
  python-dev

### set container bash prompt color to blue in order to
### differentiate container terminal sessions from host
### terminal sessions
RUN \
  echo 'PS1="\[\\e[0;94m\]${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\\\$\[\\e[m\] "' >> ~/.bashrc

### update yarn
RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

### install watchman
### Note: See the README.md to find out how to increase the
### fs.inotify.max_user_watches value so that watchman will
### work better with ember projects.
ENV WATCHMAN_VERSION v4.9.0
RUN \
  git clone https://github.com/facebook/watchman.git &&\
  cd watchman &&\
  git checkout ${WATCHMAN_VERSION} &&\
  ./autogen.sh &&\
  ./configure &&\
  make &&\
  make install

### install ember-cli
ENV EMBER_VERSION 3.8
RUN \
  yarn global add \
    ember-cli@${EMBER_VERSION} \
    ember-cli-update