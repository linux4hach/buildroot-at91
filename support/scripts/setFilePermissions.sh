#!/bin/bash 
TIMESTAMP_FILE="${TARGET_DIR}/var/log/hach/data/timestamp.txt"
SSH_PRIVATE_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/ssh*"
SSH_PUBLIC_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/*.pub"
ROOT_AUTHORIZED_KEYS_FILE="${TARGET_DIR}/root/.ssh/authorized_keys"
NOBODY_AUTHORIZED_KEYS_FILE="${TARGET_DIR}/usr/share/jail/.ssh/authorized_keys"
chmod 0666 $TIMESTAMP_FILE
chmod 0600 $SSH_PRIVATE_KEY_FILES
chmod 0644 $SSH_PUBLIC_KEY_FILES
chmod 0664 $ROOT_AUTHORIZED_KEYS_FILE
chmod 0644 $NOBODY_AUTHORIZED_KEYS_FILE




