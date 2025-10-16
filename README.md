# Lidar-IMU联合标定

本项目基于ROS1 noetic环境完成，ROS2 Humble环境请参考docker开发。

### 1. 克隆本项目
```
https://github.com/geekincode/mid360_Lidar_IMU_Init.git
```
### 2. 参考运行流程
[README_ros1.md](doc/README_ros1.md)


## Docker运行

### 1. 构建Docker镜像
```
bash 
```

### 2. 插入设备
包括：达妙IMU TypeC-USB连接、CH341串口转USB、Livox-MID360雷达

确认设备号：`/dev/ttyUSB0`(或者`/dev/ttyCH341USB0`)、`/dev/ttyACM0`

给脚本添加权限
```
sudo chmod 777 docker/build_docker.sh docker/ros_entrypoint.sh docker/run_docker.sh
```

### 3.运行Docker镜像
```
bash docker/run_docker.sh
```
