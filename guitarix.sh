#!/bin/bash

# Start guitarix in a docker container

set -euo pipefail

xhost +

data_dir="/data/Dropbox"
guitarix_config="$HOME/.config/guitarix"
shared_files="$HOME/.local/share/guitarix"

mkdir -p "$guitarix_config"

# Need to attach $HOME/.config/guitarix
# TODO does line below impact tuner error?
#     -v /run/user/$(id -u)/at-spi/bus_0:/run/user/$(id -u)/at-spi/bus_0 \
docker run -it \
    --privileged \
    --ulimit memlock=-1:-1 \
    --user=$(id -u):$(id -g) \
    -e DISPLAY=$DISPLAY \
    -e PIPEWIRE_RUNTIME_DIR=/tmp \
    -e HOME=$HOME \
    -w $HOME \
    -v $guitarix_config:$HOME/.config/guitarix \
    -v $data_dir:$HOME/models \
    -v $shared_files:$shared_files \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /run/user/$(id -u)/at-spi/bus_0:/run/user/$(id -u)/at-spi/bus_0 \
    -v /run/user/$(id -u)/pipewire-0:/tmp/pipewire-0 \
    -- guitarix pw-jack guitarix
