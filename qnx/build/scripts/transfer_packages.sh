#!/bin/sh

TARGET_IP=$1
if [ -z "$TARGET_IP" ]; then
  echo "Usage: $0 <target_ip>"
  exit 1
fi

mkdir -p /tmp/wheels
python3.11 -m pip download \
  --only-binary=:all: \
  --platform manylinux2014_aarch64 \
  --implementation cp \
  --python-version 3.11 \
  --abi cp311 \
  -d /tmp/wheels \
  PyYAML==6.0.2

# packaging / lark
python3.11 -m pip download \
  --only-binary=:all: \
  -d /tmp/wheels \
  packaging==23.2 lark==1.1.9

scp -r /tmp/wheels root@$TARGET_IP:/data
scp -r ./target/* root@$TARGET_IP:/data
scp ~/qnx803/target/qnx/aarch64le/ros2_humble.tar.gz root@$TARGET_IP:/data
