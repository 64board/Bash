#!/bin/bash
# Creates a tar.gz file compressing a directory.
# janeiros@mbfcc.com
# 2021-09-09

usage() { echo "Usage: $(basename $0) -b <localbin|opt|www> -d <backup files directory>" 2>&1; exit 1; }

# Specify user home directory.
USER_NAME=

COMMAND=tar

BACKUP_DIR=/home/${USER_NAME}/backup

DATE=$(date +%Y%m%d)

while getopts "b:d:" o;
do
    case "${o}" in
        b)
            b=${OPTARG}
            [[ ${b} =~ opt|www|localbin ]] || usage
            ;;
        d)
            d=${OPTARG}
            [[ -d ${d} ]] || usage
            BACKUP_DIR="${d}"
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${b}" -o -z "${d}" ];
then
    usage
fi

case "${b}" in
    localbin)
        FILES_DIR=/usr/local/bin
        COMMAND_OPTIONS="-cvzf"
        ;;
    opt)
        FILES_DIR=/${b}
        COMMAND_OPTIONS="--exclude=mbftc*/log/* --exclude=*.log* --exclude=*pnl*.csv --exclude=*GMIRTGF1*.csv -cvzf"
        ;;
    www)
        FILES_DIR=/var/${b}/html
        COMMAND_OPTIONS="-cvzf"
        ;;
esac

BACKUP_FILE=${BACKUP_DIR}/backup_${b}_${DATE}.tar.gz

echo "${COMMAND} ${COMMAND_OPTIONS} ${BACKUP_FILE} ${FILES_DIR}"

${COMMAND} ${COMMAND_OPTIONS} ${BACKUP_FILE} ${FILES_DIR}

##END##
