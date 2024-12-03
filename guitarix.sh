#!/bin/bash

# Start guitarix in a docker container

set -euo pipefail

models_dir="/data/Dropbox"
guitarix_config="$HOME/.config/guitarix"
shared_files="$HOME/.local/share/guitarix"

# Add usage function
usage() {
    echo "Usage: $0"
    echo "  Start guitarix in a docker container"
    exit 1
}

# Add option for data directory
while getopts m opt; do
    case {$opt} in
        m)
            models_dir="$OPTARG"
            ;;
        \?)
            usage
            ;;
    esac
done

xhost +

# expand variable and check it begins with a slash
models_dir=$(echo $models_dir)
if [[ ! $models_dir =~ ^/ ]]; then
    echo "Models directory must be an absolute path"
    exit 1
fi
# Format model dir, remove slash and all
models_dir=$(echo $models_dir | sed 's:/*$::')

if [ ! -d "$models_dir" ]; then
    echo "Models directory does not exist: $models_dir"
    exit 1
fi

echo "Using models directory: $models_dir"

# Create guitarix config directory if it doesn't exist
if [ ! -d "$guitarix_config" ]; then
    echo "Creating guitarix config directory: $guitarix_config"
    mkdir -p "$guitarix_config"
fi

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
    -v $models_dir:$HOME/models \
    -v $shared_files:$shared_files \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /run/user/$(id -u)/at-spi/bus_0:/run/user/$(id -u)/at-spi/bus_0 \
    -v /run/user/$(id -u)/pipewire-0:/tmp/pipewire-0 \
    -- guitarix pw-jack guitarix
