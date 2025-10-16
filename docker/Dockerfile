# Dockerfile for mid360 Lidar IMU Init project
# Based on Ubuntu 20.04 and ROS Noetic

FROM ros:noetic

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive

# 使用清华镜像源（更稳定）并配置git
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --fix-missing \
        cmake \
        build-essential \
        libeigen3-dev \
        libpcl-dev \
        python3-pip \
        python3-tk \
        wget \
        vim \
        git \
        # 安装通用linux头文件支持内核模块编译
        linux-headers-generic \
        # 安装udev支持设备管理
        udev \
        libatlas-base-dev \
        libgoogle-glog-dev \
        libsuitesparse-dev \
        libglew-dev \
        ros-noetic-rviz \
        ros-noetic-pcl-ros \
        ros-noetic-eigen-conversions \
        ros-noetic-nav-msgs \
        ros-noetic-geometry-msgs \
        ros-noetic-sensor-msgs \
        ros-noetic-tf \
        ros-noetic-serial \
        software-properties-common \
        # X11显示支持
        libx11-dev \
        libxt-dev \
        libgl1-mesa-glx \
        libxrender1 \
        libxext6 \
        xvfb \
        # 添加中文字体和locale支持
        locales \
        fonts-wqy-microhei \
        language-pack-zh-hans \
        # && rm -rf /var/lib/apt/lists/* \
        # 配置中文locale
        && locale-gen zh_CN.UTF-8 \
        && update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8

# Install Python packages - 使用清华镜像源
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple matplotlib numpy \
    # 配置 git 网络设置来解决 TLS 连接问题
    && git config --global http.version HTTP/1.1 \
    && git config --global http.sslVerify false \
    && git config --global https.sslVerify false \
    && git config --global http.postBuffer 1048576000 \
    && git config --global http.lowSpeedLimit 0 \
    && git config --global http.lowSpeedTime 999999

# 设置使用系统默认的gcc/g++编译器，并配置内核模块编译环境
ENV CC=gcc
ENV CXX=g++
ENV KBUILD_NOPEDANTIC=1

# Install Ceres Solver
WORKDIR /home/
RUN wget https://github.com/ceres-solver/ceres-solver/archive/refs/tags/2.0.0.tar.gz \
    && tar zxf 2.0.0.tar.gz \
    && rm 2.0.0.tar.gz \
    && cd ceres-solver-2.0.0 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$(nproc) \
    && make install \
    && cd ../.. \
    && rm -rf ceres-solver-2.0.0

# Create catkin workspace
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws

# Copy project source code
COPY . /root/catkin_ws

# Extract CH341 driver but don't compile it during build
RUN cd /root/catkin_ws/thirdparty && \
    unzip CH341SER_LINUX.ZIP

# Build Livox-SDK2
RUN cd /root/catkin_ws/thirdparty/Livox-SDK2 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j$(nproc) \
    && make install

# Build serial library
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    cd /root/catkin_ws/thirdparty/serial && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install"

# Build project
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    bash ./sh/build.sh"

RUN chmod 777 /root/catkin_ws/docker/ros_entrypoint.sh

WORKDIR /root/catkin_ws

ENTRYPOINT ["./docker/ros_entrypoint.sh"]
CMD ["bash"]