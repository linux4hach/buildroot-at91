#!/bin/bash
SEARCH_CRITERIA="QWS_MOUSE_PROTO"
PROFILE="${TARGET_DIR}/etc/profile"
RESULTS_OF_SEARCH=$(grep -c $SEARCH_CRITERIA $PROFILE)
NONE_FOUND="0"

echo "$SEARCH_CRITERIA"
echo "$PROFILE"
echo "$RESULTS_OF_SEARCH"



if [ "$RESULTS_OF_SEARCH" == "$NONE_FOUND" ]
then 
   echo -e "\n" >> $PROFILE
   echo "# These lines set up the Touch Screen for use" >> $PROFILE
   echo "export TSLIB_TSDEVICE=/dev/input/event1" >> $PROFILE 
   echo "export TSLIB_TSEVENTTYPE=INPUT" >> $PROFILE
   echo "export TSLIB_CONFFILE=/etc/ts.conf" >> $PROFILE
   echo "export TSLIB_CALIBFILE=/etc/pointercal" >> $PROFILE
   echo "export QWS_MOUSE_PROTO=\"Tslib:/dev/input/event1\"" >> $PROFILE

fi

