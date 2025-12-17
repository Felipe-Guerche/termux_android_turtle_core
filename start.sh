#!/bin/bash
# Minimal Supervisor for Headless SLAM
export TURTLEBOT3_MODEL=burger
source /opt/ros/noetic/setup.bash

# Clean Logic (Optional but safe)
pkill -f ros
pkill -f xvfb
rm -f ~/turtle_ws/session.log

# Launch with nohup and xvfb to persist
nohup xvfb-run -a roslaunch ~/turtle_ws/system.launch > ~/turtle_ws/session.log 2>&1 &

echo "System started via roslaunch. Check session.log for details."
