#!/bin/bash 
INTERFACES_FILE="${TARGET_DIR}/etc/network/interfaces"
SEARCH_CRITERIA="eth0"
TRUE_VALUE="0"

RESULT_FROM_COMPARISON=$(grep -c $SEARCH_CRITERIA $INTERFACES_FILE)

if [ "$RESULT_FROM_COMPARISON" == "$TRUE_VALUE" ] ;
then
   echo "auto eth0" >> $INTERFACES_FILE 
   echo "iface eth0 inet dhcp" >> $INTERFACES_FILE
fi
