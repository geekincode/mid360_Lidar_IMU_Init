#!/bin/bash

# colcon build --cmake-args -DROS_EDITION=ROS2 -DHUMBLE_ROS=humble -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE --event-handlers console_direct+
colcon build --cmake-args -DROS_EDITION=ROS2 -DHUMBLE_ROS=humble -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE --packages-select livox_ros_driver2

source install/setup.bash 

# colcon build --parallel-workers 10 --packages-ignore pcd2pgm livox_ros_driver2
colcon build --parallel-workers 8 --event-handlers console_direct+ --packages-ignore livox_ros_driver2 

# export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
# fast_lio库链接问题

# 需添加编译选项

# --symlink-install