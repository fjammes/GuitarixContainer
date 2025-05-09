# Build: docker build . -t guitarix
# Run: xhost + && docker run -it  -v /tmp/.X11-unix:/tmp/.X11-unix -v /run/user/1000/pipewire-0:/tmp/pipewire-0 -e PIPEWIRE_RUNTIME_DIR=/tmp -e DISPLAY=$DISPLAY guitarix
# TODO plug pipewire: https://stackoverflow.com/questions/68973199/pipewire-audio-in-fedora-container
FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

ENV GUITARIX_VERSION=V0.46.0

RUN apt-get update -y && apt-get install -y \
        apt-utils \
        git \
        sudo \
        gperf \
        intltool \
	build-essential \
        libavahi-gobject-dev \
        libbluetooth-dev \
        libboost-dev \
        libboost-iostreams-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libeigen3-dev \
        libgtk-3-dev \
        libgtkmm-3.0-dev \
        libjack-dev \
        liblilv-dev \
        liblrdf0-dev \
        libsndfile1-dev \
        libfftw3-dev \
        lv2-dev \
        python3.12 \
        python3.12-venv \
        sassc \
        fonts-roboto \
        pipewire-jack \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --groups audio,pipewire --uid 1001 --shell /bin/bash guitarix
USER guitarix 
WORKDIR /home/guitarix

RUN python3 -m venv python3

RUN git clone --depth 1 --branch $GUITARIX_VERSION https://github.com/brummer10/guitarix.git && \
    cd guitarix && \
    git submodule update --init --recursive

RUN . /home/guitarix/python3/bin/activate && \
    cd guitarix/trunk && \
    ./waf configure --prefix=/usr --includeresampler --includeconvolver --optimization --no-faust && \
    ./waf build

USER root
RUN sh -c ". /home/guitarix/python3/bin/activate && cd /home/guitarix/guitarix/trunk && ./waf install"

USER guitarix
RUN mkdir -p /home/guitarix/.config/guitarix/

