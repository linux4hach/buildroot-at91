#! /bin/bash

BASE_DIR=/opt/HachDev
INSTALLATION_DIR=$BASE_DIR/BuildSystems/cm130 

if [[ $USER == "root" ]]; then
   echo "Please do not run this script with sudo or as a root user!"
   exit
fi

if [ -d $INSTALATION_DIR ]
then
   
   cp -Rpfv * $INSTALLATION_DIR

else
   echo "The installation directory does not already exist, please type sudo mkdir -p $INSTALATION_DIR  then type chown -R $USER:$USER $BASE_DIR"

fi


