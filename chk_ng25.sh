#!/bin/bash
# Check CME STP energy trades with 2 digits year contracts.
# janeiros@mbfcc.com
# 2024-01-17

usage() { echo "Usage: $(basename $0) [-p|-d <yyyy-mm-dd>]" 2>&1; exit 1; }

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

    echo $(date -d -${DAYS}day +${DATE_FORMAT})
}

LOG_DIR=/opt/cme_stp/log
DATE_FORMAT='%Y-%m-%d'

while getopts "d:ph" o;
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
        *)
            usage
            ;;
    esac
done

if [ -z "${DATE}" ];
then
    FILE_NAME=${LOG_DIR}/cme_stp.log
else
    FILE_NAME=${LOG_DIR}/cme_stp.log.${DATE}
fi

echo "Searching ${FILE_NAME} ..."

egrep 'TR:|INSERT' ${FILE_NAME} | egrep -A 1 '(CL|HO|NG|RB)[NQUVXZ]2[5-9]'

##END##
