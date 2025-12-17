# 🤖 Termux Turtle Core
**Headless ROS Noetic Navigation Stack for Android/Termux**

> This repository houses the optimized configuration to run the TurtleBot3 navigation stack on a resource-constrained Android device (via Termux), bridging custom hardware to standard ROS tools like Foxglove Studio.

## 🏗 Architecture
*   **Hardware:** Custom Mobile Base (TurtleBot3 compatible) + Android Device (Compute).
*   **OS:** Ubuntu 20.04 (via Proot/Termux) on `armv7l/aarch64`.
*   **Middleware:** ROS Noetic (Headless).
*   **Visualization:** Remote (Foxglove Studio).

## 🚀 Quick Start
### 1. Launch the Stack
This single command handles `Xvfb` (virtual display) and background process detachment:
```bash
./start.sh
```
*Logs are written to `~/turtle_ws/session.log`.*

### 2. Connect Remote Visualization
Open **Foxglove Studio** on your PC and connect to:
`ws://<ANDROID_IP>:9090`

## 📂 Key Files
*   **`system.launch`**: Combined launcher for Stage, Gmapping, and Rosbridge.
*   **`start.sh`**: Daemon wrapper for robust headless execution.
*   **`turtlebot_low_cost.world`**: Optimized simulation environment (Low CPU/Bandwidth).

## 🔧 Optimizations
*   **LIDAR Throttling**: 5Hz limit to ensure stability on ARM CPUs.
*   **Map Updates**: Reduced frequency (2.0s) to save bandwidth.
*   **Topic Whitelist**: Blocks `/clock` and heavy topics from Rosbridge to prevent crashes.

## 🛠 Development Workflow (PC ↔ Android)
You can develop and refine files locally on your PC, but follow these rules to ensure the code works on the Android robot:

1.  **Source Code Only**: Never sync the `build/` or `devel/` folders. They contain compiled binaries specific to your PC's CPU (x86), which will **break** on Android (ARM).
2.  **Recompile on Device**: After moving changes to the phone (via Git or SSH), always run:
    ```bash
    cd ~/turtle_ws
    catkin_make
    source devel/setup.bash
    ```
3.  **Architecture Check**: PC simulators (like Gazebo) allow heavy physics. This project uses `stage_ros` specifically because it is lightweight enough for Android. Avoid adding heavy sensors or complex 3D meshes.
4.  **Testing**:
    *   **Logic (Launch/Python):** Safe to test on PC.
    *   **Performance (Hz/CPU):** MUST be validated on the Android device.

## 🛠 Development Workflow (PC ↔ Android)
You can develop and refine files locally on your PC, but follow these rules to ensure the code works on the Android robot:

1.  **Source Code Only**: Never sync the `build/` or `devel/` folders. They contain compiled binaries specific to your PC's CPU (x86), which will **break** on Android (ARM).
2.  **Recompile on Device**: After moving changes to the phone (via Git or SSH), always run:
    ```bash
    cd ~/turtle_ws
    catkin_make
    source devel/setup.bash
    ```
3.  **Architecture Check**: PC simulators (like Gazebo) allow heavy physics. This project uses `stage_ros` specifically because it is lightweight enough for Android. Avoid adding heavy sensors or complex 3D meshes.
4.  **Testing**:
    *   **Logic (Launch/Python):** Safe to test on PC.
    *   **Performance (Hz/CPU):** MUST be validated on the Android device.
