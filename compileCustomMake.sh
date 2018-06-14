#! /bin/bash
ABSPATH=$(readlink -f $0)
CURRENT_DIR="$(dirname $ABSPATH)"
TOOLS_DIR="${CURRENT_DIR}/tools"
MAKE_DIR="${TOOLS_DIR}/make-3.82"
MAKE_FILE="${MAKE_DIR}/make"
if [ ! -f ${MAKE_FILE} ]; then
   cd $MAKE_DIR
   ./configure > /dev/null 2>&1
   make -j$(nproc) > /dev/null 2>&1
fi
echo ${MAKE_FILE}

