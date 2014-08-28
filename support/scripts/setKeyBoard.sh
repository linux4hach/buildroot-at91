#!/bin/bash
SEARCH_CRITERIA="QWS_KEYBOARD"
PROFILE="${TARGET_DIR}/etc/profile"
RESULTS_OF_SEARCH=$(grep -c $SEARCH_CRITERIA $PROFILE)
NONE_FOUND="0"

echo "$SEARCH_CRITERIA"
echo "$PROFILE"
echo "$RESULTS_OF_SEARCH"



if [ "$RESULTS_OF_SEARCH" == "$NONE_FOUND" ]
then 
   echo -e "\n" >> $PROFILE
   echo "#I added this line to enable the temporary keyboard" >> $PROFILE
   echo "export QWS_KEYBOARD=\"LinuxInput:/dev/input/event0\"" >> $PROFILE

fi

