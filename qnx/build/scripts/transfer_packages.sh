#!/bin/sh
mkdir -p /tmp/wheels
python3.11 -m pip download --only-binary=:all: \
  -d /tmp/wheels \
  "packaging==23.2" "pyparsing==3.1.2" "PyYAML==6.0.2" "distro==1.8.0" "lark==1.1.9"

scp -r /tmp/wheels root@192.168.23.251:/data
scp -r ./target/* root@192.168.23.251:/data
scp ~/qnx803/target/qnx/aarch64le/ros2_humble.tar.gz root@192.168.23.251:/data
