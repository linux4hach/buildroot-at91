#!/bin/bash 
INTERFACES_FILE="${TARGET_DIR}/etc/network/interfaces"
SEARCH_CRITERIA="eth0"
NONE_FOUND="0"

RESULT_FROM_COMPARISON=$(grep -c $SEARCH_CRITERIA $INTERFACES_FILE)
echo "$RESULT_FROM_COMPARISON"

if [ "$RESULT_FROM_COMPARISON" == "$NONE_FOUND" ] 
then
   echo "auto eth0" >> $INTERFACES_FILE 
   echo "iface eth0 inet dhcp" >> $INTERFACES_FILE
fi
