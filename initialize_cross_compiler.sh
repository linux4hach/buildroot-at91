#!/bin/bash
SEARCH_PATH=$PWD
REQUIRED_PART="sdk/r1307"
if [[ ${SEARCH_PATH} != *"$REQUIRED_PART"* ]]; then

  echo "You are not in the required directory for this script to run, please CD to ../$REQUIRED_PART before executing this command!"
else

  make hach-at91sam9g35_init_defconfig
  make clean all;


fi


