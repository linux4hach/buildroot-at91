#!/bin/bash
if [ "$1" == "clean" ]; then
   make O=./sdcard clean
fi 

make O=./sdcard hach-at91sam9g35_sdcard_working_defconfig
make O=./sdcard
