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

#
# !!NOTE!!
# BR2_ROOTFS_OVERLAY is defined when running 'make menuconfig' and is defined
#                    within the 'system' section of the configure system

BUILDROOT_DIR=/opt/Programs/buildroot-at91
BUILDROOT_CONFIGS_DIR=$BUILDROOT_DIR/configs
BUILDROOT_OUTPUT_DIR=$BUILDROOT_DIR/output
BUILDROOT_OUTPUT_TARGET_DIR=$BUILDROOT_OUTPUT_DIR/target
DIRNAME=$(which dirname)
TARGET_CONFIG_NAME=hach-at91sam9g35_nor_defconfig
TARGET_CONFIG_FILE=$BUILDROOT_CONFIGS_DIR/$TARGET_CONFIG_NAME

if [ -d $BUILDROOT_DIR ]
then
    if [ -f $TARGET_CONFIG_FILE ]
    then
        source $TARGET_CONFIG_FILE
    else
        exit 23 # could not find the config file
    fi
fi

ETC_DIR=etc
HACH_ETC_DIR=usr/share/hach/etc
TARGET_ETC_DIR=$BUILDROOT_OUTPUT_TARGET_DIR/$ETC_DIR
RFS_HACH_ETC_DIR=${BR2_ROOTFS_OVERLAY}/$HACH_ETC_DIR
SHADOW=shadow
TARGET_SHADOW_FILE=$TARGET_ETC_DIR/$SHADOW
HACH_SHADOW_FILE=$RFS_HACH_ETC_DIR/$SHADOW
PASSWD=passwd
RFS_PASSWD_FILE=${BR2_ROOTFS_OVERLAY}/$ETC_DIR/$PASSWD

CAT=$(which cat)
CP=$(which cp)
CUT=$(which cut)
ECHO=$(which echo)
GREP=$(which grep)
LN=$(which ln)
MV=$(which mv)
RM=$(which rm)


#! copy the shadow file from the target location
#! to a read/write location on the root filesystem
pusf__copy_shadow_file()
{
    if [ -n $CP ]
    then
        if [ -n ${BR2_ROOTFS_OVERLAY} -a -e $TARGET_SHADOW_FILE ]
        then
            if [ -n $DIRNAME ]
            then
                if [ -d $($DIRNAME ${HACH_SHADOW_FILE}) ]
                then
                    $CP $TARGET_SHADOW_FILE ${HACH_SHADOW_FILE}
                else
                    return 121 # @retval 121 - destination directory not found
                fi
            else
                return 123 # @retval 123 - dirname not found
            fi
        else
            return 125 # @retval 125 - target file not found
        fi
    else
        return 127 # @retval 127 - error finding a 'copy' exectuable
    fi

    return 0  # @retval 0 - successful in finding a 'move' exectuable
}


#! remove lines within a file matching a received string
#! also provide the ability to append a string
#!
#! @param $1 file to parse
#! @param $2 string used to remove lines containing the match
#! @param $3 string to append to file
pusf__parse_file_remove_lines()
{
    local File="${1}"
    if [ -f "${1}" \
        -a -n ${GREP} \
        -a -n ${MV} \
        -a -n ${RM} ]
    then
        local Needle="${2}"
        local NumberOfOccurrences=$(${GREP} -c "${Needle}" "${File}")
        local AppendLine="${3}"
        local InterimFile="${File}.interim"


        if [ -z "${Needle}" ]
        then
            return 123 # @retval 123 - $2 is not valid
        fi

        if [ 0 -ne $NumberOfOccurrences ]
        then
            ${RM} -f "${InterimFile}"

            # remove Needle from the haystack [File]
            ${GREP} -v "^${Needle}" "${File}" >> "${InterimFile}"
        fi

        $(${ECHO} $AppendLine >> "${InterimFile}")
        ${MV} -f "${InterimFile}" "${File}"

    else
        return 127 # @retval 127 - the received file or one of the binaries does not exist
    fi

}


#! enter some specific information into the passwd and shadow files
pusf__update_shadow_and_passwd_files()
{
    if [ -n ${CAT} -a -n ${CUT} -a -n ${ECHO} -a -n ${GREP} ]
    then
        if [ -n ${BR2_ROOTFS_OVERLAY} -a \
            -f ${HACH_SHADOW_FILE}  -a \
            -f ${RFS_PASSWD_FILE} ]
        then
            local RfsSourceDir=${BR2_ROOTFS_OVERLAY}/../source
            local RfsScriptsDir=${RfsSourceDir}/scripts
            local RfsUpdatesFile=${RfsScriptsDir}/etcFileUpdates.sh

            if [ -f ${RfsUpdatesFile} ]
            then
                source ${RfsUpdatesFile}

                local TargetString=$(echo "${UPDATE_PASSWD_STRING}" | "${CUT}" -d':' -f1)

                pusf__parse_file_remove_lines "${HACH_SHADOW_FILE}" "${TargetString}" "${UPDATE_SHADOW_STRING}"

                if [ 0 -eq $? ]
                then
                    pusf__parse_file_remove_lines "${RFS_PASSWD_FILE}" "${TargetString}" "${UPDATE_PASSWD_STRING}"
                    return $?
                fi
            fi

        fi
    else
        return 127 #! @retval 127 - needed binaries do not exist
    fi

    return 0  # @retval 0 - successful in finding a 'move' exectuable
}


if [ -n ${BR2_ROOTFS_OVERLAY} ]
then
    pusf__copy_shadow_file

    if [ 0 -eq $? ]
    then
        pusf__update_shadow_and_passwd_files
        exit $?
    fi

    exit $?
else
    exit 21 #! @retval 21 - BR2_ROOTFS_OVERLAY is not populated
fi

