# Running Guitarix Inside Docker

## Prerequisites

- **Operating System**: Ubuntu 24.04
- **Docker**: Version 24.0.6-rd (or later)
- **PipeWire**: Version 1.0.5 (or later)

## Building the Docker Image

To build the Guitarix Docker image locally, optimized for your architecture in order to reduce latency, simply run:

```bash
./build.sh
```

## Running the Docker Container

To run guitarix inside a container execute the following script:

```bash
./guitarix.sh
```

To check GuitarixContainer advanced options run:

```bash
./guitarix.sh -h
```

## Additional Information

For more details or related discussions, please open an issue on the project page.

## Archive

Initial GitHub issue: [Guitarix Issue #171](https://github.com/brummer10/guitarix/issues/171).
