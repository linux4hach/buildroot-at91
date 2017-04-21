#! /bin/bash

BASE_DIR=/opt/HachDev
INSTALLATION_DIR=$BASE_DIR/BuildSystems/cm130
CROSS_COMPILER=$INSTALLATION_DIR/buildroot-at91-crosscompiler-root/output/host
CROSS_TOOLS=$CROSS_COMPILER/usr/share/bin
TEST_FOR_USER=$(whoami)
GET_OWNER=$(ls -ld $INSTALATION_DIR | cut -d' ' -f3) 
LIST_OF_USERS=$(cut -d: -f1 /etc/passwd)
SPECIFIED_USER=$1

copy_files()
{
   sudo -H -u $SPECIFIED_USER cp -Rpfv * $CROSS_COMPILER
}

set_ownership()
{
   chown -R $TEST_FOR_USER:$TEST_FOR_USER $BASE_DIR
}

if [[ ($TEST_FOR_USER == "root") && ($LIST_OF_USERS == *$SPECIFIED_USER*) ]]; then
  echo "Installing crosscompiler";
else 
  echo "Installation Failed....Please run this script as sudo cm130_CrossCompiler_Install.run $SPECIFIED_USER "
  exit
fi



if [ -d $INSTALATION_DIR ]
then
   
   if [[ $GET_OWNER != $TEST_FOR_USER ]]; then
      set_ownership

   fi
   copy_files

else
   mkdir -p $INSTALLATION_DIR
   set_ownership
   copy_files
fi

BIN_DIR=${HOME}/bin

if [-d $BIN_DIR ]
then

   sudo -H -u $SPECIFIED_USER mkdir -p $BIN_DIR

fi

sudo -H -u $SPECIFIED_USER ln -sf $CROSS_TOOLS $BIN_DIR 
