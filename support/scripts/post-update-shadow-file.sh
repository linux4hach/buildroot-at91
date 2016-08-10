#!/bin/bash
#
#! @file post-update-shadow-file.sh
#!
#! @brief move the shadow file to "/usr/share/hach/etc/shadow" and create a
#!        symbolic link from "/etc/shadow".
#!
#! @copyright
#!
#! @author Donald Froien
#!
#! @version 0.1.0.0
#

POF__SOURCE_FILE="./support/scripts/post-op-functions.sh"
if [ -f  "${POF__SOURCE_FILE}" ]
then
    source "${POF__SOURCE_FILE}"
else
    exit 19 # needed file does not exist
fi

if [ -n ${BR2_ROOTFS_OVERLAY} ]
then

    pusf__source_etc_update_file

    if [ 0 -ne $? ]
    then
        exit 27 # update file was not sourced
    fi

    if [ -f "${RFS_UPDATES_FILE}" ]
    then
        source "${RFS_UPDATES_FILE}"
    fi
    for UPDATE_SHADOW_STRING in "${UPDATE_SHADOW_STRING_LIST[@]}";
    do
        pusf__update_colon_delimited_file "${BR_TARGET_HACH_ETC_DIR}/${SHADOW}" \
                                      "${UPDATE_SHADOW_STRING}"
    done
    if [ 0 -ne $? ]
    then
        exit 25 # updating first colon delimited file failed
    fi
    for UPDATE_PASSWD_STRING in "${UPDATE_PASSWD_STRING_LIST[@]}";
    do
        pusf__update_colon_delimited_file "${BR_TARGET_ETC_DIR}/${PASSWD}" \
                                      "${UPDATE_PASSWD_STRING}"
    done
    if [ 0 -ne $? ]
    then
        exit 23 # updating second colon delimited file failed
    fi

    pusf__symlink_target_to_link "${BR_TARGET_HACH_ETC_DIR}/${SHADOW}" \
                                 "${BR_TARGET_ETC_DIR}/${SHADOW}" \
                                 "/${HACH_ETC_DIR}"

else
    exit 21 #! @retval 21 - BR2_ROOTFS_OVERLAY is not populated
fi

exit $?

