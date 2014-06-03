#!/bin/bash
SEARCH_CRITERIA="QWS_MOUSE_PROTO"
PROFILE="${TARGET_DIR}/etc/profile"
if [grep -q $SEARCH_CRITERIA $PROFILE]==0; then 
   echo -e "\n" >> $PROFILE
   echo "# These lines set up the Touch Screen for use" >> $PROFILE
   echo "export TSLIB_TSDEVICE=/dev/input/event1" >> $PROFILE 
   echo "export TSLIB_TSEVENTTYPE=INPUT" >> $PROFILE
   echo "export TSLIB_CONFFILE=/etc/ts.conf" >> $PROFILE
   echo "export TSLIB_CALIBFILE=/etc/pointercal" >> $PROFILE
   echo "export QWS_MOUSE_PROTO=\"Tslib:/dev/input/event1\"" >> $PROFILE

fi

