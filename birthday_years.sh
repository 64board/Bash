#!/bin/bash

# List all years between birthday's year and current one when
# day of the week matches birthday's day of the week, also lists
# next year after the last on the list that matches.

# Uses DATE(1) bash command to do date calculations.
# No other external command required.

# 64board@gmail.com

usage() { echo -e  "Usage: $(basename $0) -d <YYYYMMDD>\nWhere YYYYMMDD is birthday's date." 2>&1; exit 1; }

while getopts "d:" o;
do
    case "${o}" in
        d)
            BIRTH_DATE=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${BIRTH_DATE}" ];
then
    usage
fi

BIRTH_YEAR=${BIRTH_DATE:0:4}
BIRTH_MONTH=${BIRTH_DATE:4:2}
BIRTH_DAY=${BIRTH_DATE:6:2}
# Use date command to find birthday's day of the week.
BIRTH_WDAY=$(date --date=${BIRTH_DATE} +%A)

echo "Birthday was on ${BIRTH_WDAY} ${BIRTH_YEAR}-${BIRTH_MONTH}-${BIRTH_DAY}"

CURRENT_YEAR=$(date +%Y)

# Loop over the years finding years that match birthday's day of the week.
for (( YEAR = ${BIRTH_YEAR}; YEAR <= ${CURRENT_YEAR}; YEAR++ ))
do
    DATE="${YEAR}-${BIRTH_MONTH}-${BIRTH_DAY}"
    # Use date command to find the day of the week for the birthday date in a year.
    WDAY=$(date --date=${DATE} +%A)

    if [ ${WDAY} = ${BIRTH_WDAY} ]
    then
        echo "${DATE} was a ${WDAY}"
    fi

done

echo "Next match will be:"

# Find next year after the current one that matches.
WDAY=''
until [ "${WDAY}" = "${BIRTH_WDAY}" ]
do
    DATE="${YEAR}-${BIRTH_MONTH}-${BIRTH_DAY}"
    WDAY=$(date --date=${DATE} +%A)
    let YEAR++
done

echo "${DATE} is a ${WDAY}"

##END##
