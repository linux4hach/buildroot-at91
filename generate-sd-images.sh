#!/bin/bash
make O=./sdcard clean
make O=./sdcard hach-at91sam9g35sdc_defconfig
make O=./sdcard
