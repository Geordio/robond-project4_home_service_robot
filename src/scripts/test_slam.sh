#!/bin/sh
xterm -T "source" -e  "source ../../devel/setup.bash; roscore" &

export ROBOT_INITIAL_POSE="-x -0 -y 0 -Y 0"
export $TURTLEBOT_3D_SENSOR="kinect"
echo $ROBOT_INITIAL_POSE


sleep 5
xterm -T "Gazebo" -e  "source ../../devel/setup.bash;roslaunch turtlebot_gazebo turtlebot_world.launch;read" &
sleep 5
#xterm -e "rosrun teleop_twist_keyboard teleop_twist_keyboard.py" &
xterm -T "telop" -e "source ../../devel/setup.bash;roslaunch turtlebot_teleop keyboard_teleop.launch" &
sleep 5
#xterm -T "gslam" -e "source ../../devel/setup.bash;roslaunch gmapping slam_gmapping_pr2;read" &
xterm -T "gslam" -e "source ../../devel/setup.bash;roslaunch turtlebot_gazebo gmapping_demo.launch;read" &
sleep 5
xterm -T "rviz" -e "source ../../devel/setup.bash;roslaunch turtlebot_rviz_launchers view_navigation.launch;read" &
