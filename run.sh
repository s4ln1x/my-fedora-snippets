#!/usr/bin/env bash

SCRIPT_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]-$0}")")"

podman run --rm -it --privileged --userns keep-id -v "${SCRIPT_PATH}"/../hello:/home/fedora-packager/hello:z -w /home/fedora-packager/hello localhost/fedora-env:v1 bash