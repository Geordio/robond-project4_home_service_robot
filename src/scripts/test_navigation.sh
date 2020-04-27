#!/bin/sh
xterm -T "source" -e  "source ../../devel/setup.bash; roscore" &

export ROBOT_INITIAL_POSE="-x -4 -y 1 -Y 0"
export $TURTLEBOT_3D_SENSOR="asus_xtion_pro"
echo $ROBOT_INITIAL_POSE


sleep 5
xterm -T "Gazebo" -e  "source ../../devel/setup.bash;roslaunch turtlebot_gazebo turtlebot_world.launch;read" &
sleep 5
xterm -T "Gazebo" -e  "source ../../devel/setup.bash;roslaunch turtlebot_gazebo amcl_demo.launch;read" &
sleep 5
xterm -T "rviz" -e "source ../../devel/setup.bash;roslaunch turtlebot_rviz_launchers view_navigation.launch;read" &
