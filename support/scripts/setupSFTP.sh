#!/bin/bash
VSFTPD_CONF="${TARGET_DIR}/etc/vsftpd.conf"
NEW_VSFTPD_CONF="${SCRIPTS_DIR}/alternate-vsftpd.conf"
BKP=".bkp"
VSFTPD_CONF_BKP=$VSFTPD_CONF$BKP

if [[ ! -f $VSFTPD_CONF_BKP ]] 

then

   mv $VSFTPD_CONF $VSFTPD_CONF_BKP
   cp $NEW_VSFTPD_CONF $VSFTPD_CONF

fi
