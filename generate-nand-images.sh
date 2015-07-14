#!/bin/bash
if [ "$1" == "clean" ]; then
make clean
fi 

make hach-at91sam9g35_nand_defconfig
make
