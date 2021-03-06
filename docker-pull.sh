#!/bin/bash
. ./functions.sh

case $1 in
  pull)
    docker_load_or_pull ubuntu:14.10
    docker_save_if_necessary ubuntu:14.10
    ;;
  clear)
    for i in ruby node golang; do
      docker rmi nabeken/ubuntu-14-10-"${i}"
    done
    sudo ./nuke-graph-directory.sh /var/lib/docker
    ;;
  serial)
    for i in ruby node golang; do
      docker pull nabeken/ubuntu-14-10-"${i}"
    done
    ;;
  parallel)
    for i in ruby node golang; do
      docker pull nabeken/ubuntu-14-10-"${i}" &
    done
    wait
    ;;
esac
