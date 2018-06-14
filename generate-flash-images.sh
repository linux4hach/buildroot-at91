#!/bin/bash
MAKE_DIR=$(./compileCustomMake.sh)
PATH=${MAKE_DIR}:$PATH
make hach-at91sam9g35_nor_defconfig
make "$@"

