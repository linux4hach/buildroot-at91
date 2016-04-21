#!/bin/bash
#
#! @file post-op-functions.sh
#
#! @detail This file provides some variables and functions needed by scripts
#!         requiring access to files that will exist on the final rootfs.
#!
#! @copyright
#!
#
#! @author Donald Froien
#!
#! @version 0.1.0.0

PUSF_DEBUG=0
LOGFILE="./pusf_output.out"
BUILDROOT_DIR=${PWD}
TARGET_CONFIG_NAME="${BUILDROOT_CONFIG}"

if [ -d $BUILDROOT_DIR -a -f "${BUILDROOT_DIR}/.config" ]
then
    source "${BUILDROOT_DIR}/.config"
else
    exit 23 # could not find the config file
fi

BUILDROOT_CONFIGS_DIR="${CONFIG_DIR}"
BUILDROOT_OUTPUT_DIR="${BUILDROOT_DIR}/output"
BUILDROOT_OUTPUT_TARGET_DIR="${BUILDROOT_OUTPUT_DIR}/target"

ETC_DIR="etc"
PASSWD="passwd"
SHADOW="shadow"

#
# !!NOTE!!
# BR2_ROOTFS_OVERLAY is defined when running 'make menuconfig' and is defined
#                    within the 'system' section of the configure system
RFS_ETC_DIR="${BR2_ROOTFS_OVERLAY}/${ETC_DIR}"
RFS_ETC_SHADOW_FILE="${RFS_ETC_DIR}/${SHADOW}"
RFS_ETC_PASSWD_FILE="${BR2_ROOTFS_OVERLAY}/${ETC_DIR}/$PASSWD"

HACH_ETC_DIR="usr/share/hach/${ETC_DIR}"
RFS_HACH_ETC_DIR="${BR2_ROOTFS_OVERLAY}/${HACH_ETC_DIR}"
RFS_HACH_ETC_SHADOW_FILE="${RFS_HACH_ETC_DIR}/${SHADOW}"

BR_TARGET_ETC_DIR="${BUILDROOT_OUTPUT_TARGET_DIR}/${ETC_DIR}"
BR_TARGET_SHADOW_FILE="${BR_TARGET_ETC_DIR}/${SHADOW}"
BR_TARGET_HACH_ETC_DIR="${BUILDROOT_OUTPUT_TARGET_DIR}/${HACH_ETC_DIR}"

BASENAME=$(which basename)
CAT=$(which cat)
CP=$(which cp)
CUT=$(which cut)
DIRNAME=$(which dirname)
ECHO=$(which echo)
GREP=$(which grep)
LN=$(which ln)
MV=$(which mv)
RM=$(which rm)


#! copy the shadow file from the buildroot target location
#! to a read/write location on the root filesystem
#
#! @param[in] ${1} source file
#! @param[in] ${2} destination file
#
pusf__copy_file()
{
    if [ -n $CP -a \
         -n "${1}" -a \
         -n "${2}" ]
    then
        local Source="${1}"
        local Destination="${2}"

        if [ -f "${Source}" ]
        then
            if [ -n $DIRNAME ]
            then
                if [ -d $($DIRNAME "${Destination}") ]
                then
                    $CP "${Source}" "${Destination}"
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

#! create symbolic link as /etc/shadow -> /usr/share/hach/etc/shadow
#
#! @param[in] ${1} target file
#! @param[in] ${2} link to create
#! @param[in] ${3} directory for the link (replaces target file's directory)
#
pusf__source_etc_update_file()
{
    local RfsScriptsDir="$(${DIRNAME} ${BR2_ROOTFS_OVERLAY})/source/scripts"
    local RfsUpdatesFile="${RfsScriptsDir}/etcFileUpdates.sh"

    if [ -f "${RfsUpdatesFile}" ]
    then
        source "${RfsUpdatesFile}"
    else
        return 127 # update file does not exist
    fi

    return 0
}


#! create symbolic link as /etc/shadow -> /usr/share/hach/etc/shadow
#
#! @param[in] ${1} target file
#! @param[in] ${2} link to create
#! @param[in] ${3} directory for the link (replaces target file's directory)
#
pusf__symlink_target_to_link()
{
    local Target="${1}"

    if [ -f "${Target}" ]
    then
        if [ -n ${MV} -a \
             -n ${LN} -a \
             -n ${BASENAME} ]
        then
            local Link="$(${BASENAME} ${2})"
            local DerivedSrcDir="$(${DIRNAME} ${2})"
            local RcvdLinkDir="${3}"

            if [ -e "${RcvdLinkDir}/${Link}" ]
            then
                ${RM} -f "${RcvdLinkDir}/${Link}"
            fi

            if [ 0 -eq $? -a \
                 -d "${DerivedSrcDir}" ]
            then
                local FinalLink=""
                if [ -n "${RcvdLinkDir}" ]
                then
                    FinalLink="${RcvdLinkDir}"/"${Link}"
                else
                    FinalLink="${Target}"
                fi

                pushd "${DerivedSrcDir}"
                ${LN} -sf "${FinalLink}" "${Link}"
                popd

            else
                return 123 # moving the file failed
            fi
        else
            return 125 # the move or link command does not exist
        fi
    else
        [[ -L "${RcvdLinkDir}/${Link}" ]] && return 0

        return 127 # the RFS_SHADOW_FILE does not exist
    fi

    return 0
}


#! append a line to a file
#
#! @param[in] $1 name of file
#! @param[in] $2 string to append to the file
pusf__append_string_to_file()
{
    local File="${1}"
    local AppendString="${2}"

    if [ -f "${File}" -a \
         -n "${AppendString}" ]
    then
        $("${ECHO}" $AppendString >> "${File}")
    else
        return 127 # the file does not exist, or the append string is empty
    fi

    return 0
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
        else
            return 0
        fi

        if [ -f "${InterimFile}" ]
        then
            ${MV} -f "${InterimFile}" "${File}"
        fi

    else
        return 127 # @retval 127 - the received file or one of the binaries does not exist
    fi

}


#! enter some specific information into the colon delimited file
#
#! @param[in] ${1} received target file to parse
#! @param[in] ${2} received string to use when parsing
#
pusf__update_colon_delimited_file()
{
    if [ -n ${CUT} ]
    then
        local RcvdTargetFile="${1}"
        local RcvdUpdateString="${2}"

        if [ -f "${RcvdTargetFile}" -a \
             -n "${RcvdUpdateString}" -a \
             -n "${BASENAME}" -a \
             -n "${ECHO}" ]
        then
            local TargetString="$(${ECHO} "${RcvdUpdateString}" | "${CUT}" -d':' -f1)"

            write_output_string $(${BASENAME} $0) $LINENO "${RcvdTargetFile}"
            write_output_string ""             0       "${TargetString}"
            write_output_string ""             0       "${RcvdUpdateString}"

            pusf__parse_file_remove_lines "${RcvdTargetFile}" \
                                          "${TargetString}" \
                                          "${RcvdUpdateString}"

            if [ 0 -ne $? ]
            then
                return $? # failed to remove the target lines from the file
            fi
            
            pusf__append_string_to_file "${RcvdTargetFile}" \
                                       "${RcvdUpdateString}"
        fi
    else
        return 127 #! @retval 127 - needed binaries do not exist
    fi

    return $?  # @retval 0 - successful in finding a 'move' exectuable
}


#! output the variables for debugging
#
#! @param[in] $1 - name of this file
#! @param[in] $2 - line number this function was called from
#! @param[in] $3 - array of strings
pusf__output_variables()
{
    pusfFilename="${LOGFILE}"

    echo $BUILDROOT_DIR >> "${pusfFilename}"
    echo $TARGET_CONFIG_NAME >> "${pusfFilename}"
    echo $BUILDROOT_CONFIGS_DIR >> "${pusfFilename}"
    echo $BUILDROOT_OUTPUT_DIR >> "${pusfFilename}"
    echo $BUILDROOT_OUTPUT_TARGET_DIR >> "${pusfFilename}"

    echo $ETC_DIR >> "${pusfFilename}"
    echo $PASSWD >> "${pusfFilename}"
    echo $SHADOW >> "${pusfFilename}"

    echo $RFS_ETC_DIR >> "${pusfFilename}"
    echo $RFS_ETC_SHADOW_FILE >> "${pusfFilename}"
    echo $RFS_ETC_PASSWD_FILE >> "${pusfFilename}"

    echo $HACH_ETC_DIR >> "${pusfFilename}"
    echo $RFS_HACH_ETC_DIR >> "${pusfFilename}"
    echo $RFS_HACH_ETC_SHADOW_FILE >> "${pusfFilename}"

    echo $BR_TARGET_ETC_DIR >> "${pusfFilename}"
    echo $BR_TARGET_SHADOW_FILE >> "${pusfFilename}"

    echo $CAT >> "${pusfFilename}"
    echo $CP >> "${pusfFilename}"
    echo $CUT >> "${pusfFilename}"
    echo $DIRNAME >> "${pusfFilename}"
    echo $ECHO >> "${pusfFilename}"
    echo $GREP >> "${pusfFilename}"
    echo $LN >> "${pusfFilename}"
    echo $MV >> "${pusfFilename}"
    echo $RM >> "${pusfFilename}"

}


#! write output to the logfile for debugging
#
#! @param[in] ${1} name of file calling this function
#! @param[in] $2 line, of file, where the function was called
#! @param[in] ${3} string to be printed
write_output_string()
{
    if [ 0 -lt $PUSF_DEBUG ]
    then
        if [ -n "${1}" -a \
             0 -lt $2 ]
        then
            echo "File/Line: $(basename ${1}), $2" >> "${LOGFILE}"
        fi

        echo "    Value:  ${3}" >> "${LOGFILE}"
    fi
}



