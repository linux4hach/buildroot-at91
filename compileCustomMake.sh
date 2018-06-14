#! /bin/bash
ABSPATH=$(readlink -f $0)
CURRENT_DIR="$(dirname $ABSPATH)"
TOOLS_DIR="${CURRENT_DIR}/tools"
MAKE_DIR="${TOOLS_DIR}/make-3.82"
if [ ! -d ${MAKE_DIR} ]; then
   cd $TOOLS_DIR 
   tar zxf make-3.82.tar.gz
   cd $MAKE_DIR
   ./configure > /dev/null 2>&1
   make -j$(nproc) > /dev/null 2>&1
fi
echo ${MAKE_DIR}

