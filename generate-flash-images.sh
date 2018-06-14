#!/bin/bash
unset PERL_MM_OPT
MAKE_DIR=$(./compileCustomMake.sh)
export PATH=${MAKE_DIR}:${PATH}
make hach-at91sam9g35_nor_defconfig
${MAKE_DIR}/make "$@"

