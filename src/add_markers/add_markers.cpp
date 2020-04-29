#include <ros/ros.h>
#include <visualization_msgs/Marker.h>
#include "nav_msgs/Odometry.h"
#include<math.h>


// should subscribe to the goals but I'm going to hard code
double pickupx ;
double pickupy;
double dropoffx;
double dropoffy;

double robotx;
double roboty;
double THRESHOLD = 0.7;
enum DeliveryStatus {beforePickup, afterPickup, droppedOff};
DeliveryStatus deliverystatus = beforePickup;

// credit to tutorial for how to get odom
//http://wiki.ros.org/evarobot_odometry/Tutorials/indigo/Writing%20a%20Simple%20Subscriber%20for%20Odometry

void poseCallback(const nav_msgs::Odometry::ConstPtr& msg)
{
  double distToPickUp = 65535;
  double distToDropOff = 65535;
  // ROS_INFO("Seq: [%d]", msg->header.seq);
  // ROS_INFO("Position-> x: [%f], y: [%f], z: [%f]", msg->pose.pose.position.x,msg->pose.pose.position.y, msg->pose.pose.position.z);
  // ROS_INFO("Orientation-> x: [%f], y: [%f], z: [%f], w: [%f]", msg->pose.pose.orientation.x, msg->pose.pose.orientation.y, msg->pose.pose.orientation.z, msg->pose.pose.orientation.w);
  // ROS_INFO("Vel-> Linear: [%f], Angular: [%f]", msg->twist.twist.linear.x,msg->twist.twist.angular.z);

  robotx = msg->pose.pose.position.x;
  roboty = msg->pose.pose.position.y;

  // double delatDist = sqrt(pow(pickupx - robotx,2) + pow(pickupy - roboty,2));

  // check if near to pickup
  if (deliverystatus == beforePickup) {
    // then check distance to pickupx

    double delatDist = sqrt(pow(pickupx - robotx,2) + pow(pickupy - roboty,2));


        ROS_INFO("BeforePU. delta: %f",delatDist );
        // ROS_INFO("robotx, roboty %f,%f (deltaxy %2f,%2f)",robotx,roboty, pickupx - robotx, pickupy - roboty );

        // sleep(100);
    if (delatDist <= THRESHOLD) {
        ROS_INFO("AfterPU. delta: %f",delatDist );
      deliverystatus = afterPickup;
    }
  }
  // hide the pickupmarker
  // calculate the eucludean distance to droppedOff
  else if (deliverystatus == afterPickup) {
    // ROS_INFO("afterpickup");
    // show the drop off marker
    double delatDist = sqrt(pow(dropoffx - robotx,2) + pow(dropoffy - roboty,2));
            ROS_INFO("afterpickup. delta: %f",delatDist );
    if (delatDist <= THRESHOLD) {
      deliverystatus = droppedOff;
              ROS_INFO("droppedoff");

    }
  }
  else if (deliverystatus == afterPickup) {
              ROS_INFO("droppedoff");
  }
  else  {
        ROS_INFO("BeforePU_default");
    // should be beforePickup
    // show pickup marker
  }
}

void displayMarker(double x, double y, bool show){


}

int main( int argc, char** argv )
{
  ros::init(argc, argv, "add_markers");
  ros::NodeHandle n;
  ros::Rate r(1);
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 1);
  //add a odom subscribe
  // // should subscribe to the goals but I'm going to hard code
  pickupx = -5;
  pickupy = 0;
  dropoffx = 3.7;
  dropoffy = -0.5;

  ros::Subscriber sub = n.subscribe("odom", 1000, poseCallback);


  // Set our initial shape type to be a cube
  uint32_t shape = visualization_msgs::Marker::CUBE;

  while (ros::ok())
  {
    visualization_msgs::Marker marker;
    // Set the frame ID and timestamp.  See the TF tutorials for information on these.
    marker.header.frame_id = "map";
    marker.header.stamp = ros::Time::now();

    // Set the namespace and id for this marker.  This serves to create a unique ID
    // Any marker sent with the same namespace and id will overwrite the old one
    marker.ns = "add_markers";
    marker.id = 0;

    // Set the marker type.  Initially this is CUBE, and cycles between that and SPHERE, ARROW, and CYLINDER
    marker.type = shape;

    // Set the marker action.  Options are ADD, DELETE, and new in ROS Indigo: 3 (DELETEALL)
    marker.action = visualization_msgs::Marker::ADD;

    //show the marker at pickup point
    // marker.pose.position.x = pickupx;
    // marker.pose.position.y = pickupy;
    marker.pose.position.z = 0;
    marker.pose.orientation.x = 0.0;
    marker.pose.orientation.y = 0.0;
    marker.pose.orientation.z = 0.0;
    marker.pose.orientation.w = 1.0;

    // Set the scale of the marker -- 1x1x1 here means 1m on a side
    marker.scale.x = 0.25;
    marker.scale.y = 0.25;
    marker.scale.z = 0.10;

    // Set the color -- be sure to set alpha to something non-zero!
    marker.color.r = 0.0f;
    marker.color.g = 1.0f;
    marker.color.b = 0.0f;
    marker.color.a = 1.0;

    marker.lifetime = ros::Duration();

    if (deliverystatus == beforePickup) {
      marker.pose.position.x = pickupx;
      marker.pose.position.y = pickupy;
    }
    else if  (deliverystatus == afterPickup) {
      marker.pose.position.x = dropoffx;
      marker.pose.position.y = dropoffy;
      marker.color.a = 0.0;
    }
    else if  (deliverystatus == droppedOff) {
      marker.pose.position.x = dropoffx;
      marker.pose.position.y = dropoffy;
      marker.color.a = 1.0;
    }
    else {
      ROS_INFO("Warning - confused delivery status");
    }


    // Publish the marker
    while (marker_pub.getNumSubscribers() < 1)
    {
      if (!ros::ok())
      {
        return 0;
      }
      ROS_WARN_ONCE("Please create a subscriber to the marker");
      ROS_INFO("FFS");
      sleep(1);
    }
    marker_pub.publish(marker);

    // Cycle between different shapes
    // switch (shape)
    // {
    // case visualization_msgs::Marker::CUBE:
    //   shape = visualization_msgs::Marker::SPHERE;
    //   break;
    // case visualization_msgs::Marker::SPHERE:
    //   shape = visualization_msgs::Marker::ARROW;
    //   break;
    // case visualization_msgs::Marker::ARROW:
    //   shape = visualization_msgs::Marker::CYLINDER;
    //   break;
    // case visualization_msgs::Marker::CYLINDER:
    //   shape = visualization_msgs::Marker::CUBE;
    //   break;
    // }

    // r.sleep();
    ros::spinOnce();
  }
}
