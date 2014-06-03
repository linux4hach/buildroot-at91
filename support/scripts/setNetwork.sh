#!/bin/bash

INTERFACES_FILE="${TARGET_DIR}/etc/network/interfaces"
SEARCH_CRITERIA="eth0"
if [grep -q $SEARCH_CRITERIA $INTERFACES_FILE]==0; then
   echo "auto eth0" >> $INTERFACES_FILE 
   echo "iface eth0 inet dhcp" >> $INTERFACES_FILE
fi


