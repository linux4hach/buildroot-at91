#!/bin/bash

make O=./sdcard hach-at91sam9g35_sdcard_working_defconfig "$@"
make O=./sdcard "$@" 
