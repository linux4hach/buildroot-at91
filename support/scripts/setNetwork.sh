#!/bin/bash 
INTERFACES_FILE="${TARGET_DIR}/etc/network/interfaces"
SEARCH_CRITERIA="eth0"
NONE_FOUND="0"

RESULT_FROM_COMPARISON=$(grep -c $SEARCH_CRITERIA $INTERFACES_FILE)
echo "$RESULT_FROM_COMPARISON"

if [ "$RESULT_FROM_COMPARISON" == "$NONE_FOUND" ] 
then
   echo "auto eth0" >> $INTERFACES_FILE 
   echo "iface eth0 inet static" >> $INTERFACES_FILE
   echo "address 192.168.1.2" >> $INTERFACES_FILE 
   echo "netmask 255.255.128.0" >> $INTERFACES_FILE



fi
