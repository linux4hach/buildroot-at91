#!/bin/bash
VERSION=$1

if [ -n "$VERSION" ] & [ $(echo "$VERSION" | grep '[0-9]\{1,2\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}') ]; then

  CONFIG=hach-"$VERSION"_defconfig
  export GITTAG=hach_"$VERSION"
  make  $CONFIG
  make clean all
fi

$BUILDROOT/support/scripts/updateOverlay.sh
export GITTAG=""
make 
