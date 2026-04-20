#!/bin/bash

# 获取当前脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
file="$SCRIPT_DIR/../src/LiDAR_IMU_Init/result/Initialization_result.txt"

# 提取 Refinement Translation LiDAR to IMU (meter)
translation=$(awk '
/Refinement result:/ { flag=1; next }
flag && /Translation LiDAR to IMU/ {
    split($0, a, "=");
    gsub(/^[ \t]+|[ \t]+$/, "", a[2]);
    gsub(/[ \t]+/, ", ", a[2]);
    print "[" a[2] "]"
}' "$file")

echo "extrinsic_T: $translation"

# 提取 Refinement Homogeneous Transformation Matrix 的前 3x3 部分
matrix_values=()
flag=0

while IFS= read -r line; do
    if [[ "$line" == *"Refinement result:"* ]]; then
        flag=1
        continue
    fi

    if (( flag )) && [[ "$line" == *"Homogeneous Transformation Matrix from LiDAR to IMU:"* ]]; then
        for ((i=1; i<=3; i++)); do
            read row || break
            read -a values <<< "$row"
            matrix_values+=("${values[0]}")
            matrix_values+=("${values[1]}")
            matrix_values+=("${values[2]}")
        done
        break
    fi
done < "$file"

# 格式化 Rotation 矩阵输出（换行）
extrinsic_R="[ ${matrix_values[0]}, ${matrix_values[1]}, ${matrix_values[2]},\n\
              ${matrix_values[3]}, ${matrix_values[4]}, ${matrix_values[5]},\n\
              ${matrix_values[6]}, ${matrix_values[7]}, ${matrix_values[8]} ]"
echo -e "extrinsic_R: $extrinsic_R"