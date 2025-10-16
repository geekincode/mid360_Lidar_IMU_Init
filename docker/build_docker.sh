#!/bin/bash

# Build docker image for mid360 Lidar IMU Init project

echo "Building Docker image for mid360 Lidar IMU Init..."

docker build -f ./docker/Dockerfile -t mid360_lidar_imu_init:v2.2 .
