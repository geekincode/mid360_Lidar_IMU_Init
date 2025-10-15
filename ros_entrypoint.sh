#!/bin/bash
 
set -e

# ROS build
source "/opt/ros/noetic/setup.bash"

# Source workspace if it exists
if [ -f "/root/catkin_ws/devel/setup.bash" ]; then
    source "/root/catkin_ws/devel/setup.bash"
fi

echo "================Docker Env Ready================"

exec "$@"