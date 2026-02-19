# TAMOPSO
 3D UAV Flight-Path Planning Using Task-Allocation &amp; Archive-Guided Mutation PSO (TAMOPSO)




<img width="7800" height="3200" alt="Abstract" src="https://github.com/user-attachments/assets/f423b597-02ff-472e-b0db-01ec6713b52c" />


**3D UAV Path Optimization Using a Task-Allocation and Archive-Guided Mutation Particle Swarm Optimization Algorithm:**
Three-dimensional flight-path planning for unmanned aerial vehicles (UAVs) inherently involves multiple, often conflicting objectives—minimizing route length and energy consumption, maximizing safety by avoiding no-fly zones and high-turbulence regions, and ensuring smooth maneuverability within kinematic limits. This study presents an enhanced adaptation of the Task Allocation and Archive-Guided Mutation Particle Swarm Optimization (TAMOPSO) algorithm to address these challenges. In the proposed framework, each candidate path is encoded as a sequence of discrete 3D waypoints, while dynamic task allocation partitions the swarm into role-specific subpopulations: global explorers for broad route discovery, local refiners for obstacle-proximal optimization, and altitude managers for vertical profile adjustment. An external archive of nondominated solutions, maintained through a uniform contribution index, preserves Pareto-front diversity and guides adaptive Lévy-flight mutations that balance global exploration with local refinement according to the swarm’s convergence state. The algorithm’s effectiveness is evaluated across benchmark terrains of varying complexity, including scenarios with seven and ten peaks, obstacle clusters, and restricted airspace constraints. Comparative results against fourteen baseline algorithms demonstrate that TAMOPSO achieves up to 60\% reduction in total flight distance, and 47\% faster convergence on average, while producing smoother trajectories and more uniformly distributed Pareto fronts. Extensive loop-based Monte Carlo experiments were implemented in the MATLAB environment, confirming the statistical robustness, computational efficiency, and scalability of the proposed approach. Overall, the integration of role-based task allocation and archive-driven adaptive mutation establishes TAMOPSO as a powerful and versatile framework for intelligent, real-time UAV path optimization in complex 3D mission environments.


<img width="1920" height="698" alt="Fig abstract TAMOPSO" src="https://github.com/user-attachments/assets/608a0d0e-4d0a-455b-9fc1-99c2c2d8522a" />



# 3D UAV Path Optimization Using TAMOPSO

## Overview
This repository contains the source code used in the study:

**"3D UAV Path Optimization Using a Task-Allocation and Archive-Guided Mutation Particle Swarm Optimization Algorithm"**

The project implements a three-dimensional unmanned aerial vehicle (UAV) flight-path planning framework based on the Task Allocation and Archive-Guided Mutation Particle Swarm Optimization (TAMOPSO) algorithm.

The objective is to generate safe, efficient, and smooth UAV trajectories in complex environments while simultaneously optimizing multiple conflicting criteria, including:

- Flight distance minimization
- Energy consumption reduction
- Obstacle and no-fly-zone avoidance
- Trajectory smoothness under UAV kinematic constraints
- Pareto-front diversity

---

## Algorithm Description

Each candidate UAV path is encoded as a sequence of discrete 3D waypoints.

The TAMOPSO framework divides the swarm dynamically into role-based subpopulations:

- **Global explorers** – perform large-scale search of the environment
- **Local refiners** – optimize paths near obstacles and constraints
- **Altitude managers** – adjust vertical flight profiles

An external archive maintains nondominated solutions using a uniform contribution index.  
Adaptive Lévy-flight mutation operators guide exploration and exploitation according to swarm convergence status.

---

## Repository Structure
main.m # Main simulation entry point
TAMOPSO.m # Core optimization algorithm
initialization.m # Population initialization
fitness_function.m # Multi-objective evaluation
environment.m # Terrain and obstacle generation

/data
terrain_maps.mat # Benchmark terrain configurations

/results_example
sample_output.mat # Example output results


## Requirements

The code was developed and tested using the following environment:

### Software
- MATLAB R2024b (or later recommended)

### Operating System
- Windows 10/11, macOS, or Linux (platform independent)

### MATLAB Toolboxes
The following MATLAB toolboxes are required:

- Optimization Toolbox
- Statistics and Machine Learning Toolbox
- Global Optimization Toolbox (if available)

### Hardware (Recommended)
- Processor: Intel i7 / equivalent or higher
- RAM: Minimum 8 GB (16 GB recommended for Monte Carlo simulations)

### Dependencies
No external libraries or third-party packages are required.  
All algorithms are implemented using native MATLAB functions.

### Installation
1. Download or clone the repository.
2. Extract files (if downloaded as ZIP).
3. Open MATLAB.
4. Set the repository folder as the working directory.
5. Run:

```matlab
main
https://github.com/farhoudrasoulie/TAMOPSO.git
