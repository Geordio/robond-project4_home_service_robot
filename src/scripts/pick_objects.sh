#!/bin/sh

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# echo $DIR
# echo $BASH_SOURCE[0
#
#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
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
xterm -T "Gazebo" -e  "roslaunch turtlebot_gazebo turtlebot_world.launch" &
sleep 5
# xterm -T "Gazebo" -e  "source devel/setup.bash;roslaunch turtlebot_gazebo amcl.launch map_file:=$MAPPATH;read" &
xterm -T "Gazebo" -e  "roslaunch turtlebot_gazebo amcl_demo.launch map_file:=$MAPPATH" &
sleep 5
xterm -T "rviz" -e "roslaunch turtlebot_rviz_launchers view_navigation.launch" &
sleep 5
xterm -e "rosrun pick_objects pick_objects"
