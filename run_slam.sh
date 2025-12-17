#!/bin/bash
LOGfile=~/turtle_ws/sim.log
echo "Initializing SLAM launch sequence at $(date)" > $LOGfile

# Redirect all output to logfile (Direct append to avoid /proc dependency)
exec >> $LOGfile 2>&1

# Solution 2: Clean Python Cache (Prevent _validate_timestamp_pyc errors)
echo "Cleaning Python Bytecode..."
find ~/turtle_ws -name "*.pyc" -delete
find ~/turtle_ws -name "__pycache__" -delete
# Also try to clean .ros location if accessible
find ~/.ros -name "*.pyc" -delete 2>/dev/null

source /opt/ros/noetic/setup.bash
export TURTLEBOT3_MODEL=burger

# Kill any existing processes (Try multiple methods due to broken /proc)
killall -9 rosmaster roscore gzserver gzclient roslaunch python3 stageros 2>/dev/null
pkill -f ros
pkill -f gazebo
pkill -f xvfb
sleep 5

# Trap to clean up
trap "echo 'Stopping processes...'; killall -9 rosmaster roscore stageros roslaunch; kill 0" EXIT

# Solution 4: Initialization Sequence - Master First
echo "Starting roscore..."
roscore &
PID_CORE=$!

# Wait for roscore to actually be ready (Socket/ Topic check)
echo "Waiting for roscore to initialize..."
MAX_RETRIES=30
COUNT=0
until rostopic list > /dev/null 2>&1; do
    echo "Waiting for roscore... ($COUNT/$MAX_RETRIES)"
    sleep 2
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "TIMEOUT: roscore failed to start!"
        exit 1
    fi
done
echo "ROS Master is ready!"

# Solution 3: Use Sim Time (Prevent TF Extrapolation errors)
echo "Setting use_sim_time to true (Solutions applied)..."
rosparam set use_sim_time true

echo "Starting Simulation (Stage - Low Cost / Low Jitter World)..."
# Using StageROS (Requires X server, so using xvfb-run)
# Remapping base_scan to scan for compatibility
xvfb-run -a rosrun stage_ros stageros ~/turtle_ws/turtlebot_low_cost.world /base_scan:=/scan &
PID_SIM=$!
sleep 5

echo "Starting SLAM (Gmapping)..."
# Launching gmapping directly to facilitate Stage compatibility
rosrun gmapping slam_gmapping scan:=scan _base_frame:=base_link _odom_frame:=odom &
PID_SLAM=$!
sleep 5

echo "Starting Rosbridge for Foxglove (Whitelisted Topics)..."
# Solution 1: The "Surgical" Whitelist (Implemented in rosbridge_custom.launch)
# Allows: tf, scan, map, odom etc. Blocks: clock
roslaunch ~/turtle_ws/rosbridge_custom.launch &
PID_BRIDGE=$!
sleep 2

echo "All systems launched. Waiting for interrupts..."
echo "--- READY FOR FOXGLOVE ---"

# Keep script alive indefinitely (wait can be flaky in this env)
while true; do
    sleep 5
done
