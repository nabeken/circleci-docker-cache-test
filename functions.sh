#!/bin/bash
DOCKER_CACHE="${HOME}/docker2"

docker_name_to_basename() {
  echo $(echo "${1}" | tr ':/' '-').tar
}

docker_save_if_necessary() {
  local name=$1
  local fn="${DOCKER_CACHE}/$(docker_name_to_basename "${name}")"
  if [[ ! -e "${fn}" ]]; then
    echo "saving to ${fn}"
    docker save -o "${fn}" "${name}"
  fi
}

docker_load_or_pull() {
  local name=$1
  local fn="${DOCKER_CACHE}/$(docker_name_to_basename "${name}")"
  if [[ -e "${fn}" ]]; then
    echo "loading from ${fn}"
    docker load -i "${fn}"
  else
    docker pull "${name}"
  fi
}
