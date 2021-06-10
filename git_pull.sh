#! /bin/bash

# echo "password: $2"
BRANCH=master
if [ ! -z "$1" ]; then
    echo "pull branch: $1"
    BRANCH=$1
fi

echo "-----------------------------------------------------------------------"
echo "-------------------------pull duckieboat-------------------------------"
echo "-----------------------------------------------------------------------"
git pull

CONFLICTS=$(git ls-files -u | wc -l)
if [ "$CONFLICTS" -gt 0 ] ; then
   echo "There is conflict in duckieboat. Aborting"
   return 1
fi

echo "-----------------------------------------------------------------------"
echo "-----------------------pull duckieboat_ros-----------------------------"
echo "-----------------------------------------------------------------------"
cd catkin_ws/src/duckieboat_ros/
git checkout $BRANCH
git pull

CONFLICTS=$(git ls-files -u | wc -l)
if [ "$CONFLICTS" -gt 0 ] ; then
   echo "There is conflict in duckieboat_ros. Aborting"
   return 1
fi

cd ~/duckieboat/
return 0