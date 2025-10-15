#!/bin/bash

# Run docker container for mid360 Lidar IMU Init project

CONTAINER_NAME="mid360_lidar_imu_init"

# Allow X11 forwarding for GUI applications
xhost +local:root

# Get the dialout group ID from host
DIALOUT_GID=$(getent group dialout | cut -d: -f3)

# Run the container with GUI support, device passthrough and proper volumes
docker run --privileged -it \
    --name=${CONTAINER_NAME} \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
    --volume=/lib/modules:/lib/modules:rw \
    --device=/dev/ttyUSB0:/dev/ttyUSB0 \
    --group-add ${DIALOUT_GID} \
    --net=host \
    --ipc=host \
    --shm-size=1gb \
    --env="DISPLAY=$DISPLAY" \
    mid360_lidar_imu_init:v2.0 \
    /bin/bash