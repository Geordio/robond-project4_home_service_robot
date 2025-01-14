#!/bin/sh

SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH
cd $SCRIPTPATH
cd ../..
echo "path"
echo $(pwd)
MAPPATH=$(pwd)"/src/map/map.yaml"
echo $MAPPATH

xterm -T "source" -e  "source devel/setup.bash; roscore" &
# export TURTLEBOT_GAZEBO_MAP_FILE="../../map/map.yaml"
export TURTLEBOT_GAZEBO_MAP_FILE=$MAPPATH
# export ROBOT_INITIAL_POSE="-x -4 -y 1 -Y 0"
export TURTLEBOT_3D_SENSOR="kinect"
# echo $ROBOT_INITIAL_POSE



sleep 5
xterm -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5
# xterm -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo amcl.launch map_file:=$MAPPATH;read" &
xterm -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo amcl_demo.launch map_file:=$MAPPATH" &
sleep 5
xterm -T "rviz" -e "source devel/setup.bash;roslaunch turtlebot_rviz_launchers view_navigation.launch" &
