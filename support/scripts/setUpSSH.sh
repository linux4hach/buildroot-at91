#!/bin/bash
SEARCH_CRITERIA="Ciphers aes128-cbc"
PROFILE="${TARGET_DIR}/etc/ssh/sshd_config"
RESULTS_OF_SEARCH=$(grep -c $SEARCH_CRITERIA $PROFILE)
NONE_FOUND="0"

echo "$SEARCH_CRITERIA"
echo "$PROFILE"
echo "$RESULTS_OF_SEARCH"



if [ "$RESULTS_OF_SEARCH" == "$NONE_FOUND" ]
then 
   echo -e "\n" >> $PROFILE
   echo "# I added this Cipher in order to support ssh on our target" >> $PROFILE
   echo $SEARCH_CRITERIA >> $PROFILE

fi

echo "here" >> myoutput.stuff


