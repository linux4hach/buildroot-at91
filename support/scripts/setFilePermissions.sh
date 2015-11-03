#!/bin/bash 
TIMESTAMP_FILE="${TARGET_DIR}/var/log/hach/data/timestamp.txt"
SSH_PRIVATE_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/ssh*"
SSH_PUBLIC_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/*.pub"
ROOT_SSH_FOLDER="${TARGET_DIR}/root/.ssh"
NOBODY_FOLDER="${TARGET_DIR}/usr/share/jail"
NOBODY_SSH_FOLDER="${NOBODY_FOLDER}/.ssh"
ROOT_AUTHORIZED_KEYS_FILE="${ROOT_SSH_FOLDER}/authorized_keys"
NOBODY_AUTHORIZED_KEYS_FILE="${NOBODY_SSH_FOLDER}/authorized_keys"
BACKUPS_FOLDER="${TARGET_DIR}/var/backups"
BACKUPS_SSH_FOLDER="${BACKUPS_FOLDER}/.ssh"
BACKUPS_AUTHORIZED_KEYS_FILE="${BACKUPS_SSH_FOLDER}/authorized_keys"
EMPTY_FILE_LOCATION="${TARGET_DIR}/var/empty"

chmod 0666 $TIMESTAMP_FILE
chmod 0600 $SSH_PRIVATE_KEY_FILES
chmod 0644 $SSH_PUBLIC_KEY_FILES
chmod 0644 $ROOT_AUTHORIZED_KEYS_FILE
chmod 0644 $NOBODY_AUTHORIZED_KEYS_FILE
chmod 0700 $ROOT_SSH_FOLDER
chmod 0755 $NOBODY_FOLDER
chmod 0705 $NOBODY_SSH_FOLDER
chmod 0755 $BACKUPS_FOLDER
chmod 0644 $BACKUPS_AUTHORIZED_KEYS_FILE
chmod 0705 $BACKUPS_SSH_FOLDER
chmod -R 0755 $EMPTY_FILE_LOCATION




