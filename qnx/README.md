Documentation for QNX ROS2 Humble https://ros2-qnx-documentation.readthedocs.io/en/humble/

# Compile the port for QNX

**NOTE**: QNX ports are only supported from a Linux host operating system

Currently the port is supported for QNX SDP 7.1 and 8.0.

We recommend that you use Docker to build ros2 for QNX to ensure the build environment consistency.

## Use Docker to build

Don't forget to source qnxsdp-env.sh in your SDP.

```bash
# Set QNX_SDP_VERSION to be qnx800 for SDP 8.0 or qnx710 for SDP 7.1
export QNX_SDP_VERSION=qnx803
export TARGET_IP=192.168.23.251

# source qnxsdp-env.sh in your SDP
source ~/qnx803/qnxsdp-env.sh

# Create a workspace
mkdir -p ~/ros2_workspace && cd ~/ros2_workspace

# Clone googletest
git clone https://github.com/qnx/googletest && cd googletest
git checkout 792c30ac6226e95ba4e08ded16bcccb011bd9f76
cd -

# Clone ros2
git clone -b qnx-sdp8-humble-release https://github.com/tatsuyai713/qnx-ros2
mv qnx-ros2 ros2

# Build the Docker image
cd  ~/ros2_workspace/ros2/qnx/build/docker
./docker-build-qnxros2-image.sh

# Create a Docker container using the built image
./docker-create-container.sh
```

```bash
# Once you're in the image, set up environment variables
. ./env/bin/activate
. ./$QNX_SDP_VERSION/qnxsdp-env.sh

# Import ros2 packages
cd ~/ros2_workspace/ros2
mkdir -p src
vcs import src < ros2.repos

# Run required scripts
./qnx/build/scripts/colcon-ignore.sh
./qnx/build/scripts/patch.sh

# Build googletest
cd ~/ros2_workspace/googletest
JLEVEL=4 make  -C qnx/build install

# Build ros2
cd ~/ros2_workspace/ros2
export CPU=aarch64
./qnx/build/scripts/build-ros2.sh

# Transfer the built files to your host machine
cd ~/ros2_workspace/ros2/qnx/build
scp $QNX_TARGET/$CPUVARDIR/ros2_humble.tar.gz root@$TARGET_IP:/data
```
## Target setup
On the target, extract the transferred tarball and source the setup script.

```bash
cd /data
./extract_and_install_packages.sh
. ./set_env.sh
```

You can now run ROS2 nodes on the QNX target.
For example, run the demo_nodes_cpp node:

```bash
ros2 launch demo_nodes_cpp talker_listener.launch.py
```
