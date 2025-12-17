# Walkthrough - TurtleBot 3 Remote SLAM & Visualization

We have upgraded the simulation to support Mapping (SLAM) and enhanced visualization.

## 1. System Status
- **Simulation**: `stage_ros` (2D Simulator, Willow Garage map).
- **Why Stage?**: The remote armhf architecture does not support Gazebo/TurtleBot3 natively.
- **SLAM**: `gmapping` running on top of Stage.
- **Bridge**: `rosbridge_websocket` on port 9090.

## 2. Running the Environment
The new script `run_slam.sh` handles everything (Simulation + SLAM + Bridge).

**Start Simulation:**
```bash
python3 ssh_client.py "nohup ~/turtle_ws/run_slam.sh > /dev/null 2>&1 &"
```

**Check Status:**
```bash
python3 ssh_client.py "tail -n 10 ~/turtle_ws/sim.log"
```

## 3. Foxglove Studio Configuration (Crucial)
To fix the "Display Frame" issue and see the map:

1.  **Open Foxglove** and connect to `ws://192.168.15.32:9090`.
2.  **3D Panel Setup**:
    - **Display Frame**: Change from `base_link` to `map` (or `odom` if `map` is missing).
    - *Note*: If `map` is not in the list, SLAM hasn't initialized yet. Drive the robot slightly to trigger it.
3.  **Visualization Topics** (Toggle these ON):
    - **Map**: `/map` (Visualization Type: `OccupancyGrid`).
    - **Laser Scan**: `/scan` (Visualization Type: `LaserScan`).
        - *Style*: Points, Size: 3px, Color: Red (for visibility).
    - **Robot**: `/tf` usually handles the position.
        - Since we don't stream the full URDF mesh relative to `/base_link`, you might just see TF axes.
        - *Workaround*: Use a "Shape" marker if available, or just rely on the TF axes arrows moving.

## 4. Teleoperation (Driving the Robot)
To map the environment, you must drive the robot. Open a **new terminal** locally:

```bash
python3 ssh_client.py "source /opt/ros/noetic/setup.bash; export TURTLEBOT3_MODEL=burger; roslaunch turtlebot3_teleop turtlebot3_teleop_key.launch"
```
*Use W/A/S/D keys to drive. Keep this terminal focused.*

## 5. Troubleshooting
- **No Map?** Drive the robot. Gmapping needs movement updates.
- **Time Sync Issue?** If usage seems laggy, it's because we are forwarding heavy JSON via websockets. Reduce frame rate in Foxglove if possible.
