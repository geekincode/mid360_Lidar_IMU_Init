#!/bin/bash
 
set -e

# ROS build
source "/opt/ros/noetic/setup.bash"

# Source workspace if it exists
if [ -f "/root/catkin_ws/devel/setup.bash" ]; then
    source "/root/catkin_ws/devel/setup.bash"
fi

# Set ROS environment variables if not already set
if [ -z "$ROS_MASTER_URI" ]; then
    export ROS_MASTER_URI=http://localhost:11311
fi

if [ -z "$ROS_IP" ] && [ -z "$ROS_HOSTNAME" ]; then
    export ROS_IP=127.0.0.1
fi

echo "================Docker Env Ready================"

exec "$@"