#!/bin/bash
MAKE_DIR=$(./compileCustomMake.sh)
PATH=${MAKE_DIR}:$PATH
make  O=./sdcard hach-at91sam9g35_sdcard_defconfig "$@"
make  O=./sdcard "$@"
