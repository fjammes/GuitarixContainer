#!/bin/bash

# Build guitarix in a docker image

set -euo pipefail

docker build . -t guitarix
