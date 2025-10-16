#!/bin/bash

echo "Downloading third party libraries..."

# 创建重试函数
retry_command() {
    local command=$1
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts: $command"
        eval $command
        if [ $? -eq 0 ]; then
            echo "Success: $command"
            return 0
        else
            echo "Failed: $command"
            if [ $attempt -lt $max_attempts ]; then
                echo "Waiting 5 seconds before retrying..."
                sleep 5
            fi
            ((attempt++))
        fi
    done
    
    echo "Failed to execute after $max_attempts attempts: $command"
    return 1
}

# 检查thirdparty目录是否存在，如果不存在则创建
if [ ! -d "thirdparty" ]; then
    mkdir -p thirdparty
fi

cd thirdparty

# 下载CH341SER驱动并添加重试机制
retry_command "wget 'https://www.wch.cn/download/file?id=177' \
     --content-disposition \
     --user-agent='Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0' \
     --referer='https://www.wch.cn/downloads/CH341SER_LINUX_ZIP.html'"

if [ $? -eq 0 ] && [ -f "CH341SER_LINUX.ZIP" ]; then
    unzip CH341SER_LINUX.ZIP
    rm CH341SER_LINUX.ZIP
else
    echo "Failed to download or find CH341SER_LINUX.ZIP"
    exit 1
fi

# 克隆GitHub仓库并添加重试机制
retry_command "git clone https://github.com/Livox-SDK/Livox-SDK2.git"
if [ $? -ne 0 ]; then
    echo "Failed to clone Livox-SDK2 repository"
    exit 1
fi

retry_command "git clone https://github.com/wjwwood/serial.git"
if [ $? -ne 0 ]; then
    echo "Failed to clone serial repository"
    exit 1
fi

cd Livox-SDK2
retry_command "git checkout 6a940156dd7151c3ab6a52442d86bc83613bd11b"
if [ $? -ne 0 ]; then
    echo "Failed to checkout specific commit in Livox-SDK2"
    exit 1
fi

cd ../serial
retry_command "git checkout 69e0372cf0d3796e84ce9a09aff1d74496f68720"
if [ $? -ne 0 ]; then
    echo "Failed to checkout specific commit in serial"
    exit 1
fi

echo "All third party libraries downloaded successfully!"