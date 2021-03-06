#!/bin/bash



if [ ! "$1" ]; then
    echo "commit detail please"
    return
fi
echo "commit: $1"

COMMIT=$1
BRANCH=master

if [ ! -z "$2" ]; then
    echo "operator on branch: $2"
    BRANCH=$2
fi

source git_pull.sh $BRANCH
PULLSTAT=$?
if [ "$PULLSTAT" -gt 0 ] ; then
   echo "There is conflict. Aborting"
   cd ~/duckieboat/
   return
fi
echo "-------------------------pull success----------------------------------"

# push duckieboat_ros
echo "-----------------------------------------------------------------------"
echo "-------------------------push duckieboat_ros---------------------------"
echo "-----------------------------------------------------------------------"
cd ~/duckieboat/catkin_ws/src/duckieboat_ros/
git add -A
git commit -m "$1 on bridge"
git push

# push duckieboat
echo "-----------------------------------------------------------------------"
echo "------------------------push duckieboat--------------------------------"
echo "-----------------------------------------------------------------------"
cd ~/duckieboat/
git add -A
git commit -m "$1"
git push 
