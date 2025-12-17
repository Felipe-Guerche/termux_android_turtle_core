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
