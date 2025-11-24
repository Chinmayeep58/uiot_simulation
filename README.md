### Underwater Internet of Things (UIoT) Simulation – MATLAB

## Overview

This project simulates a simplified Underwater Internet of Things (UIoT) environment using a 5-layer architecture. The MATLAB script models sensor behavior, underwater acoustic communication, packet loss, mobility, fog-node fusion, and basic anomaly detection.

The goal is to observe how underwater node movement and acoustic propagation affect delay, attenuation, packet loss, and overall network connectivity.

---

## Features

1. **Environment Setup**

   * Creates a 3D underwater region with user-defined dimensions.
   * Deploys random underwater sensor nodes and fixed fog nodes.

2. **Sensing Layer Simulation**

   * Generates temperature, salinity, and depth data for each node at every time step.

3. **Communication Layer**

   * Computes node–fog distances.
   * Calculates delay using the acoustic propagation speed (1500 m/s).
   * Applies Thorp’s absorption model to estimate attenuation.
   * Models packet-loss as a function of distance and attenuation.

4. **Networking Layer**

   * Assigns each sensor node to the nearest fog node.
   * Determines whether nodes are within communication range.
   * Prints connectivity logs for each time step.

5. **Fusion and Cloud Layers**

   * Fog nodes compute local averages of temperature and salinity from connected nodes.
   * Cloud node receives fused data for higher-level analytics.

6. **Application Layer (Simplified)**

   * Performs basic anomaly detection by identifying nodes whose temperature exceeds a dynamic threshold.

7. **Mobility Model**

   * Applies random drift to sensor nodes to simulate underwater currents.
   * Ensures nodes remain within simulated boundaries.

8. **Visualization**

   * 3D plot showing node positions, fog nodes, cloud node, and active links.
   * Bar graph showing delay, packet loss, and number of connected nodes over time.

---

## Output

* Console logs showing connectivity, delay, and packet loss.
* Real-time 3D visualization of node mobility and fog connectivity.
* Performance charts showing system-wide delay and packet-loss trends.
* Basic anomaly warnings when sensor readings exceed threshold values.

---

ides
