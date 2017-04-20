#! /bin/bash

INSTALLATION_DIR=/opt/HachDev/BuildSystems/cm130 

if [[ $USER == "root" ]]; then
   echo "Please do not run this script with sudo or as a root user!"
   exit
fi

if [ -d $INSTALATION_DIR ]
then
   
   cp -Rpfv * $INSTALLATION_DIR

else
   echo "The installation directory does not already exist, please type sudo mkdir $INSTALATION_DIR  then type chown -R $USER:$USER $INSTALATION_DIR"

fi


