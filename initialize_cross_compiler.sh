#!/bin/bash
SEARCH_PATH=$PWD
REQUIRED_PART="buildroot-at91-crosscompile-root"
if [[ ${SEARCH_PATH} != *"$REQUIRED_PART"* ]]; then

   make hach-at91sam9g35_init_defconfig
   make clean all;
 else
  echo "You are not in the required directory for this script to run, please CD to ../$REQUIRED_PART before executing this command!"
fi


