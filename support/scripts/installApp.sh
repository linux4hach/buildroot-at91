#!/bin/bash

PROGRAMTOINSTALL=$1
REMOVETRIGGER="remove"
INSERTEDTRIGGER="mmcblk0:"
ERRORTRIGGER="error"
SDCARDMESSAGECURRENT="NULL"
SDCARDMESSAGEINSERTED="SDCARD INSERTED"
SDCARDMESSAGEREMOVED="SDCARD REMOVED"
SDCARDMESSAGEERROR="SDCARD ERROR"
SDCARDSTATUS=$(dmesg | tail -n 1)

function mountSDCard(){

  mount /dev/mmcblk0p1 /mnt/sdcard


}

function unmountSDCard(){

  umount /dev/mmcblk0p1

}

function removeAllRunningInstances(){


# look for all instances of trialProject...and echo their names at present
for x in $(ps | grep $PROGRAMTOINSTALL | grep -v grep | grep -v $0 | cut -c1-5); do kill -9 $x; done

}

while :

do
  #interogate dmesg
  SDCARDSTATUS=$(dmesg | tail -n 1)



  #issue the message the sdcard has been removed
  if grep -q $REMOVETRIGGER  <<<$SDCARDSTATUS; then
    if [ "$SDCARDMESSAGECURRENT" != "$SDCARDMESSAGEREMOVED" ]; then
      SDCARDMESSAGECURRENT=$SDCARDMESSAGEREMOVED
      echo $SDCARDMESSAGECURRENT
    fi

  fi

  if grep -q $INSERTEDTRIGGER <<<$SDCARDSTATUS; then

    if [ "$SDCARDMESSAGEINSERTED" != "$SDCARDMESSAGECURRENT" ]; then
      SDCARDMESSAGECURRENT=$SDCARDMESSAGEINSERTED
      echo $SDCARDMESSAGECURRENT
      
      echo "You have inserted an SD Card, would you like to update your software? (y or n)"
      read response

      if [ "$response" == "y" ]; then

         echo "Removing all running instances of $PROGRAMTOINSTALL"
         removeAllRunningInstances
        
         echo "Please wait until the next message..."
         mountSDCard
         cp /mnt/sdcard/zImage "/root/$PROGRAMTOINSTALL"
         unmountSDCard
         echo "You have copied $PROGRAMTOINSTALL from the SDCard to the root file system."
         echo "Exiting program!!!"
         exit
       fi
       

    fi

  fi

  if grep -q $ERRORTRIGGER <<<$SDCARDSTATUS; then

    if [ "$SDCARDMESSAGEERROR" != "$SDCARDMESSAGECURRENT" ]; then
      SDCARDMESSAGECURRENT=$SDCARDMESSAGEERROR
      echo $SDCARDMESSAGECURRENT
    fi


  fi

done








