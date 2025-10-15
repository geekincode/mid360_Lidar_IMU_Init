#!/bin/bash

# Build docker image for mid360 Lidar IMU Init project

echo "Building Docker image for mid360 Lidar IMU Init..."

docker build -t mid360_lidar_imu_init:v2.0 .

echo "Docker image built successfully!"
echo "To run the container, use:"
echo "  docker run -it --rm mid360_lidar_imu_init:v2.0"