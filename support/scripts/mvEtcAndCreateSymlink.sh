#!/bin/bash
#
# Description:
#      This is a script ran by buildroot just before the root filesystem is
# finalized. The purspose of this script is to create a symbolic link from the
# '/etc' entry to the read/write '/var/etc' directory.
#
#      The reason to perform this task is to address the need to modify scripts
# that exist in the currently read only partition where '/etc' resides.
#
#

TARGET_DIR=${TARGET_DIR}
echo $TARGET_DIR
TARBALL=${HOME}/etc.tgz
ETC_DIR=etc
RELATIVE_VAR_DIR=var
RELATIVE_DESTINATION_DIR=${RELATIVE_VAR_DIR}/etc
RELATIVE_ETC_LINK=etc



# @brief print the variables used in this script
printVars()
{
    echo "TARGET_DIR:                 " ${TARGET_DIR}
    echo "TARBALL:                    " ${TARBALL}
    echo "ETC_DIR:                    " ${ETC_DIR}
    echo "RELATIVE_VAR_DIR:           " ${RELATIVE_VAR_DIR}
    echo "RELATIVE_DESTINATION_DIR:   " ${RELATIVE_DESTINATION_DIR}
    echo "RELATIVE_ETC_LINK:          " ${RELATIVE_ETC_LINK}
}

printVars

pushd ${TARGET_DIR}

if [ -e ${ETC_DIR} -a ! -L ${ETC_DIR} ]
then
    # Create an archive for the situation where "moving" the data to the
    # destination fails.  This is our safeguard to be forced into recompiling
    # the entire system from scratch again.
    tar czf ${TARBALL} ${ETC_DIR}
    RESULT=$?
    echo "tar czf ${TARBALL} result: " ${RESULT}

    # remove the etc entry if it is not already a symbolic link

    if [ 0 -eq ${RESULT} ]
    then
        tar xzf ${TARBALL} -C ${RELATIVE_VAR_DIR}
        RESULT=$?
        echo "tar xzf ${TARBALL} result: " ${RESULT}
    fi

    if [ 0 -eq ${RESULT} ]
    then
        rm -rf ${ETC_DIR}
        RESULT=$?
        echo "rm -rf ${ETC_DIR} result: " ${RESULT}
    fi

    if [ 0 -eq ${RESULT} ]
    then
        if [ ! -d ${RELATIVE_DESTINATION_DIR} ]
        then
            mkdir ${RELATIVE_DESTINATION_DIR}
            RESULT=$?
            echo "mkdir ${RELATIVE_DESTINATION_DIR} result: " ${RESULT}
        fi

        if [ 0 -eq ${RESULT} ]
        then
            ln -sf ${RELATIVE_DESTINATION_DIR} ${RELATIVE_ETC_LINK}
            RESULT=$?
            echo "ln -sf ${RELATIVE_DESTINATION_DIR} ${RELATIVE_ETC_LINK} result: " ${RESULT}
        fi
    fi
else
    if [ ! -e ${ETC_DIR} ]
    then
        echo "${ETC_DIR} does NOT EXIST."
    fi

    if [ -e ${ETC_DIR} -a -L ${ETC_DIR} ]
    then
        echo "${ETC_DIR} exists as a link already."
    fi
fi

popd

if [ -e ${TARBALL} ]
then
    echo "removing ${TARBALL}"
    rm ${TARBALL}
fi

