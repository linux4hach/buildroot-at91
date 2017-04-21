#! /bin/bash

BASE_DIR=/opt/HachDev
INSTALLATION_DIR=$BASE_DIR/BuildSystems/cm130
CROSS_COMPILER=$INSTALLATION_DIR/buildroot-at91-crosscompiler-root/output/host
CROSS_TOOLS=$CROSS_COMPILER/usr/share/bin
TEST_FOR_USER=$(whoami)
GET_OWNER=$(ls -ld $INSTALATION_DIR | cut -d' ' -f3) 

copy_files()
{
   cp -Rpfv * $CROSS_COMPILER
}

set_ownership()
{
   sudo chown -R $TEST_FOR_USER:$TEST_FOR_USER $BASE_DIR
}


if [[ $TEST_FOR_USER == "root" ]]; then
   echo "Please do not run this script with sudo or as a root user!"
   exit
fi



if [ -d $INSTALATION_DIR ]
then
   
   if [[ $GET_OWNER != $TEST_FOR_USER ]]; then
      set_ownership

   fi
   copy_files

else
   sudo mkdir -p $INSTALLATION_DIR
   set_ownership
   copy_files
fi

ln -sf $CROSS_TOOLS ${HOME}/bin
