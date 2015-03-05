#!/bin/bash
set -e
set -o pipefail

DOCKER_CACHE="${HOME}/docker2"

docker_name_to_basename() {
  echo $(echo "${1}" | tr ':/' '-').tar
}

docker_save_if_necessary() {
  local name=$1
  local fn="${DOCKER_CACHE}/$(docker_name_to_basename "${name}")"
  if [[ ! -e "${fn}" ]]; then
    echo "saving to ${fn}"
    docker save "${name}" > "${fn}"
  fi
}

docker_load_or_pull() {
  local name=$1
  local fn="${DOCKER_CACHE}/$(docker_name_to_basename "${name}")"
  if [[ -e "${fn}" ]]; then
    echo "loading from ${fn}"
    docker load -i "${fn}"
    echo $?
  else
    docker pull "${name}"
  fi
}

for i in ubuntu:14.10 golang:1.4 postgres:9.4 redis:2.8 progrium/consul:consul-0.4 nabeken/docker-volume-container-rsync:latest; do
  {
    echo "$(LANG=C date): begin for ${i}"
    docker_load_or_pull "${i}"
    docker_save_if_necessary "${i}"
    echo "$(LANG=C date): done for ${i}"
  } &
done

wait
