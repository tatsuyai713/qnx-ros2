#!/bin/sh
BASE=/data/opt/ros/humble

export PATH="/system/bin:$BASE/bin:$PATH"                 # python3 と ros2 を見つける
export COLCON_CURRENT_PREFIX="$BASE"
export COLCON_PYTHON_EXECUTABLE=/system/bin/python3       # ament/colcon が使う Python を固定
export PYTHONPATH="$BASE/lib/python3.11/site-packages:$BASE/lib/python3.11/dist-packages:${PYTHONPATH:-}"
export LD_LIBRARY_PATH="$BASE/lib:$BASE/lib64:${LD_LIBRARY_PATH:-}"
export AMENT_PREFIX_PATH="$BASE:${AMENT_PREFIX_PATH:-}"
export CMAKE_PREFIX_PATH="$BASE:${CMAKE_PREFIX_PATH:-}"

. "$BASE/setup.sh"
