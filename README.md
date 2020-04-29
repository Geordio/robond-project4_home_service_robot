# Udacity Robotics Software Engineer Home Service Robotic

## Overview

The purpose of the task was to set up a robot to navigate from its initial pose to a pickup location, pause for 5 seconds, then move to a drop off location.
pick up and drop off points would be indicated by a marker, which should behave like an object that is being collected and dropped off.

I used the turtle bot packages that available from the ros.org website. Modified versions are included in this repository and will be included in a clone.

1.  gmapping: used to map the environment using SLAM
2.  turtlebot_teleop: Allows manual control of the robot
3.  turtlebot_rviz_launchers: RViz launch files
4.  turtlebot_gazebo: The main turtlebot gazebo files including the robot model and basic configurations

## Setting up

Cloning the repository should give you all the necessary ros packages, which will need to be sourced and built prior to running.
The repository should be cloned into a catkin_ws folder.
(so that the typical setup would be workspace/catkin_ws/src etc)

In addition if using the Udacity workspace run:  
> apt-get update && apt-get upgrade

If you receive an error relating to rospkg it can be installed with    
> pip install rospkg

## Running

It may not be the ideal method, but I modified the existing launch files in order to implement the required roslaunch robot_state_publisher

* src/turtlebot/turtlebot_simulator/turtlebot_gazebo/launch/amcl_demo.launch.
  * to configure amcl to use the appropriate map/
  * to configure DWAPlannerROS to avoid the robot spinning on route.  


* src/turtlebot/turtlebot_simulator/turtlebot_gazebo/launch/turtlebot_world.launch - to launch the appropriate world

Scripts are provided in the src/scripts folder to perform the required tasks. The main tasks are highlighted below.

### Mapping

The mapping phase can run by calling:  
> cd  src/scripts
> ./test_slam.sh

This was one of the first scripts I created in the project and must be called from the src/scripts dir.

The robot can then be driven (slowly) round the world to do the mapping. It typically took 2-3 paths of the environment before a reasonable  map could be generated.

The screenshot below shows the completion of the Mapping  

![Alt text](/screenshots/completed_mapping2.png?raw=true "mapping")

### Home Service

This is the final demonstration.
The script launches Gazebo with a bespoke world and turtlebot, launches RVIZ preconfigured, runs AMCL, and runs rosrun to run the pick_objects and add_markers nodes.

* pick_objects sends destination goals to a pickup and drop off location.
* add_markers draws a marker on the pickup location, which disappears when the robot reaches that destination, and redraws the marker at the destination once the robot has reached that location.

It can be run by:  
>  src/scripts/home_service.sh

The script is set up so that it should be possible to be called from any directory without effecting the paths.
Additionally the script changes the title on the launched xterm windows to make viewing easier.

![Alt text](/screenshots/pickingup.png?raw=true "pickingup")

### Challenges

This project was not without problems

#### Mapping  
The initial problem encountered was a difficulty in mapping the environment. The quality of the map generated is generally poor but can be improved my a methodical and slow approach to mapping.
The turtlebot x velocity was dropped to 75% of its normal, and the rotation speed dropped by 50% which appears to help.

#### Turtlebot spinning  

Once a goal has been sent to the robot, it initially had a tendancy to spin on its way to the destination.
I would always get there, but the spinning caused it to take a long time.
This can be overcome by following the  recommendation here:   
https://surfertas.github.io/rviz/turtlebot/2017/05/08/turtlepi-spin.html
