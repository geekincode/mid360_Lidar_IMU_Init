#!/bin/bash
 
set -e

# Ros build
source /opt/ros/noetic/setup.bash

# Check if USB device is available
if [ -c /dev/ttyUSB0 ]; then
    echo "CH341 USB device detected: /dev/ttyUSB0"
    # Set permissions for the device
    chmod 777 /dev/ttyUSB0 2>/dev/null || echo "Warning: Could not set permissions for /dev/ttyUSB0"
else
    echo "Warning: CH341 USB device not found or not passed through to container"
fi

# Check if ACM device is available
if [ -c /dev/ttyACM0 ]; then
    echo "ACM device detected: /dev/ttyACM0"
    # Set permissions for the device
    chmod 777 /dev/ttyACM0 2>/dev/null || echo "Warning: Could not set permissions for /dev/ttyACM0"
else
    echo "Warning: ACM device not found or not passed through to container"
fi

# Install CH341 driver at runtime if not already installed and kernel headers are available
if [ ! -f /lib/modules/`uname -r`/kernel/drivers/usb/serial/ch341.ko ] && [ -d /lib/modules/`uname -r`/build ]; then
    echo "Installing CH341 driver..."
    cd /root/catkin_ws/thirdparty/CH341SER_LINUX/driver
    make clean
    make
    make install
    cd -
elif [ ! -d /lib/modules/`uname -r`/build ]; then
    echo "Info: Kernel headers not available, skipping CH341 driver compilation."
    echo "Current kernel version: `uname -r`"
fi

echo "================Docker Env Ready================"

cd /root/catkin_ws

exec "$@"