#!/bin/sh
BASE=/data/opt/ros/humble

export PATH="/system/bin:$BASE/bin:$PATH"
export COLCON_CURRENT_PREFIX="$BASE"
export COLCON_PYTHON_EXECUTABLE=/system/bin/python3
export PYTHONPATH="$BASE/usr/lib/python3.11/site-packages:$BASE/usr/lib/python3.11/dist-packages:$BASE/lib/python3.11/site-packages:$BASE/lib/python3.11/dist-packages:${PYTHONPATH:-}"
export LD_LIBRARY_PATH="$BASE/usr/lib:$BASE/usr/lib64:$BASE/lib:$BASE/lib64:${LD_LIBRARY_PATH:-}"
export AMENT_PREFIX_PATH="$BASE:${AMENT_PREFIX_PATH:-}"
export CMAKE_PREFIX_PATH="$BASE:${CMAKE_PREFIX_PATH:-}"

. "$BASE/setup.sh"
