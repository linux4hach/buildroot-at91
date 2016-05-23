#!/bin/bash 

##### HOME Directories ######
BACKUPS_FOLDER="${TARGET_DIR}/var/backups"
KEYXFER_FOLDER="${TARGET_DIR}/var/keyxfer"
NOBODY_FOLDER="${TARGET_DIR}/usr/share/jail"

##### SSH/SCP local directories #####
BACKUPS_SSH_FOLDER="${BACKUPS_FOLDER}/.ssh"
KEYXFER_SSH_FOLDER="${KEYXFER_FOLDER}/var/keyxfer/.ssh"
NOBODY_SSH_FOLDER="${NOBODY_FOLDER}/.ssh"
ROOT_SSH_FOLDER="${TARGET_DIR}/root/.ssh"

##### SSH/SCP Authorized Keys Files #####
BACKUPS_AUTHORIZED_KEYS_FILE="${BACKUPS_SSH_FOLDER}/authorized_keys"
KEYXFER_AUTHORIZED_KEYS_FILE="${KEYXFER_SSH_FOLDER}/authorized_keys"
NOBODY_AUTHORIZED_KEYS_FILE="${NOBODY_SSH_FOLDER}/authorized_keys"
ROOT_AUTHORIZED_KEYS_FILE="${ROOT_SSH_FOLDER}/authorized_keys"

##### Miscellanious Files #####
TIMESTAMP_FILE="${TARGET_DIR}/var/log/hach/data/timestamp.txt"
SSH_PRIVATE_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/ssh*"
SSH_PUBLIC_KEY_FILES="${TARGET_DIR}/usr/share/hach/etc/*.pub"
VAR_EMPTY_LOCATION="${TARGET_DIR}/var/empty"
USR_SHARE_HACH_BIN_NTP_COPY_SCRIPT="${TARGET_DIR}/usr/share/hach/bin/ntpd_drift_file_copy.sh"

# directories with common permissions
for directory in "${KEYXFER_FOLDER}" \
                 "${BACKUPS_FOLDER}" \
                 "${NOBODY_FOLDER}" \
                 "${VAR_EMPTY_LOCATION}"
do
    # -rwxr-xr-x
    chmod 0755 "${directory}"
done


# .ssh directories permissions
for sshDir in "${ROOT_SSH_FOLDER}" \
              "${BACKUPS_SSH_FOLDER}" \
              "${KEYXFER_SSH_FOLDER}" \
              "${NOBODY_SSH_FOLDER}"
do
    # -rwx---r--
    chmod 0705 "${sshDir}"
done


# authorized keys files permissions
for authFile in "${ROOT_AUTHORIZED_KEYS_FILE}" \
                "${BACKUPS_AUTHORIZED_KEYS_FILE}" \
                "${KEYXFER_AUTHORIZED_KEYS_FILE}" \
                "${NOBODY_AUTHORIZED_KEYS_FILE}"
do
    # -rw----r--
    chmod 0604 "${authFile}"
done


# owner only file permissions
for ownerOnly in "${ROOT_SSH_FOLDER}" \
                 "${USR_SHARE_HACH_BIN_NTP_COPY_SCRIPT}"
do
    # -rwx------
    chmod 0700 "${ownerOnly}"
done


#!/bin/bash 
TIMESTAMP_FILE="${TARGET_DIR}/var/log/hach/data/timestamp.txt"
KEYXFER_PUB_KEY_FILE="${KEYXFER_FOLDER}/keys-file.pub"
KEYXFER_MD5SUM_FILE="${KEYXFER_FOLDER}/MD5SUM"
KEYXFER_SH1SUM_FILE="${KEYXFER_FOLDER}/SH1SUM"

# user access file permissions
for otherAccessFile in "${TIMESTAMP_FILE}" \
                 "${KEYXFER_PUB_KEY_FILE}" \
		 "${KEYXFER_MD5SUM_FILE}" \
		 "${KEYXFER_SH1SUM_FILE}"
do
    # -rw-rw-rw-
    chmod 0666 "${otherAccessFile}"
done

chmod 0600 $SSH_PRIVATE_KEY_FILES
chmod 0644 $SSH_PUBLIC_KEY_FILES


