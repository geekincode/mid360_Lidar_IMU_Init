import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.conditions import IfCondition
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


def generate_launch_description():
    pkg = get_package_share_directory("lidar_imu_init")
    rviz_default = os.path.join(pkg, "rviz_cfg", "spinning.rviz")
    cfg_default = os.path.join(pkg, "config", "pandar.yaml")

    rviz = LaunchConfiguration("rviz")
    config_file = LaunchConfiguration("config_file")
    rviz_cfg = LaunchConfiguration("rviz_cfg")

    return LaunchDescription([
        DeclareLaunchArgument("rviz", default_value="true"),
        DeclareLaunchArgument("config_file", default_value=cfg_default),
        DeclareLaunchArgument("rviz_cfg", default_value=rviz_default),
        Node(
            package="lidar_imu_init",
            executable="li_init",
            name="laser_mapping",
            output="screen",
            parameters=[config_file, {"point_filter_num": 5, "max_iteration": 5, "cube_side_length": 2000.0}],
        ),
        Node(
            package="rviz2",
            executable="rviz2",
            arguments=["-d", rviz_cfg],
            condition=IfCondition(rviz),
        ),
    ])
