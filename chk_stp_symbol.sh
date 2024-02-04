#!/bin/bash
# Check CME STP using symbol and date.
# janeiros@mbfcc.com
# 2024-02-04

usage() { echo "Usage: $(basename $0) [-p] -s <symbol> [-d <yyyy-mm-dd>]\n-p Previous business date" 2>&1; exit 1; }

# Get previous date based on day of the week.
# Argument is date format to use with OS date command.
get_previous_date() {
    DATE_FORMAT=${1}
    DOW=$(date +%u)

    # On Sundays get Friday's date.
    if [ ${DOW} -eq 7 ]
    then
        DAYS=2
    elif [ ${DOW} -eq 1 ] # On Mondays do as Sundays.
    then
        DAYS=3
    else
        DAYS=1  # Rest of days.
    fi

    echo $(date -d -${DAYS}day +%Y-%m-%d)
}

LOG_DIR=/opt/cme_stp/log
FILE_NAME=cme_stp.log
DATE_FORMAT='%Y-%m-%d'

while getopts "pd:s:h" o;
do
    case "${o}" in
        d)
            DATE=${OPTARG}
            [[ -n ${DATE} ]] || usage
            ;;
        p)
            DATE=$(get_previous_date ${DATE_FORMAT})
            [[ -n ${DATE} ]] || usage
            ;;
        s)
            SYMBOL=${OPTARG}
            [[ -n ${SYMBOL} ]] || usage
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${SYMBOL}" ]
then
    echo "ERROR: Symbol is required!"
    usage
    exit 1
fi

if [ -z "${DATE}" ]
then
    FILE_PATH=${LOG_DIR}/${FILE_NAME}
else
    FILE_PATH=${LOG_DIR}/${FILE_NAME}.${DATE}
fi

echo "Searching ${SYMBOL} symbol on ${FILE_PATH} ..."

egrep 'TR:|INSERT' ${FILE_PATH} | egrep "${SYMBOL}"

##END##
