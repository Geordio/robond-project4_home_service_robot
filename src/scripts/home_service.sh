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
echo $TURTLEBOT_3D_SENSOR
echo $TURTLEBOT_GAZEBO_MAP_FILE

sleep 5
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo turtlebot_world.launch; read" &
sleep 5
# xterm -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo amcl.launch map_file:=$MAPPATH;read" &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "AMCL" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo amcl_demo.launch map_file:=$MAPPATH; read" &
sleep 5
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "rviz" -e "source devel/setup.bash;roslaunch turtlebot_rviz_launchers view_markers.launch; read" &
sleep 5
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "add_markers" -e "source devel/setup.bash;rosrun add_markers add_markers" &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "pick_objects" -e "source devel/setup.bash;rosrun pick_objects pick_objects" &
