#!/bin/bash
#
#! @file post-op-remove-shadow-symlink.sh
#
#! @detail This script shall remove the symbolic link created by a previous
#!         script.  This operation is completed by looking for the shadow
#!         file in $ROOTFS/etc/shadow and determining if it is a symbolic
#!         link.  If it is, then the symbolic link is removed and a shadow
#!         file from another location is copied to the $ROOTFS/etc directory.
#
#! @copyright
#
#! @author Donald Froien
#
#! @version 0.1.0.0

POF__SOURCE_FILE="./support/scripts/post-op-functions.sh"
if [ -f "${POF__SOURCE_FILE}" ]
then
    source "${POF__SOURCE_FILE}"
else
    exit 19 # needed file does not exist
fi


if [ -z "${BR_TARGET_ETC_DIR}" ]
then
    exit 25 # RFS_ETC_DIR does not exist
fi


PORSS_TARGET_FILE="${BR_TARGET_ETC_DIR}/${SHADOW}"
PORSS_SOURCE_FILE="${BR_TARGET_HACH_ETC_DIR}/${SHADOW}"
if [ -f "${PORSS_SOURCE_FILE}" -a \
     -L "${PORSS_TARGET_FILE}" ]
then
    if [ -n ${CP} ]
    then
        if [ -e "${PORSS_TARGET_FILE}" -o \
             -L "${PORSS_TARGET_FILE}" ]
        then
            if [ -e ${RM} ]
            then
                ${RM} -f "${PORSS_TARGET_FILE}"
            else
                exit 15 # RM command does not exist
            fi
        fi

        if [ -n ${ECHO} -a \
             -n ${CUT} ]
        then
            pusf__source_etc_update_file

            if [ 0 -ne $? ]
            then
                exit 17 # failed to source the update file
            fi
	    for UPDATE_SHADOW_STRING in "${UPDATE_SHADOW_STRING_LIST[@]}";
	    do
            	   ____NAME="$(${ECHO} "${UPDATE_SHADOW_STRING}" | "${CUT}" -d':' -f1)"
            	   pusf__parse_file_remove_lines "${PORSS_SOURCE_FILE}" \
                                          "${____NAME}"
	    done
        else
            exit 19 # a echo or cut do not exist
        fi


        if [ -e "${PORSS_SOURCE_FILE}" ]
        then
            ${CP} "${PORSS_SOURCE_FILE}" "${PORSS_TARGET_FILE}"

            if [ 0 -ne $? ]
            then
                exit 21 # filed to copy the file
            fi
            

        else
            exit 23 # PORSS_SOURCE_FILE does not exist
        fi
    else
        exit 25 # CP command does not exist
    fi
else
    exit 27 # PORSS_SOURCE_FILE or PORSS_TARGET_FILE does not exist
fi

exit $?

