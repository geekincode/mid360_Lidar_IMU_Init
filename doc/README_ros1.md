mid360雷达_IMU校准

环境为：ubuntu20.04;ROS1 noetic
1. 安装Livox-SDK2
1.1. 安装CMake
```
sudo apt install cmake
```
1.2. 安装编译Livox-SDK2
```
git clone https://github.com/Livox-SDK/Livox-SDK2.git
cd ./Livox-SDK2/
mkdir build && cd build
cmake .. && make -j
sudo make install
```
2. 下载livox_ros_driver2源码
```
git clone https://github.com/Livox-SDK/livox_ros_driver2.git
cd livox_ros_driver2
./build.sh ROS1
```

3. 下载FAST_LIO源码
```
    git clone https://github.com/hku-mars/FAST_LIO.git
    cd FAST_LIO
    git submodule update --init
    cd ../..
    catkin_make
    source devel/setup.bash
```

4. source devel/setup.bash 

5. 运行达妙imu的功能包
    roslaunch dm_imu run_without_rviz.launch

6. 运行imu脚本
   bash sh/imu.sh

7. source devel/setup.bash 

8. 运行雷达驱动功能包
   roslaunch livox_ros_driver2 msg_MID360.launch

9. source devel/setup.bash

9. 运行
   roslaunch lidar_imu_init livox_mid360.launch 

10. 运行
    bash extract_marix.sh
