#!/bin/bash
unset PERL_MM_OPT
MAKE_DIR=$(./compileCustomMake.sh)
export PATH=${MAKE_DIR}:$PATH
make  O=./sdcard hach-at91sam9g35_sdcard_defconfig "$@"
make  O=./sdcard "$@"
