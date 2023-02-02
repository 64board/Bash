#!/bin/bash
# janeiros@mbfcc.com
# 2023.01.31
# Crontab entry:
# 18 10 * * * root echo 'Y' | /usr/local/bin/delete_settlements.sh > /tmp/del_settle.txt 2>&1

DB=<DATABASE>
DB_USER=<DB_USER>
DB_PASSWD=<DB_PASSWORD>

# Query for table with count by dates.
SQL_DAYS="select date, count(*) as rows from settlements group by date order by date;"

# Query for count of days with settlements.
SQL_DAYS_COUNT="select count(*) from (select date from settlements group by date order by date) days;"

# First date to be deleted.
SQL_FIRST_DAY="select date from settlements group by date order by date limit 1;"

# Show first table with settlement count by dates.
mysql --user=${DB_USER} --password=${DB_PASSWD} --database=${DB} --execute="${SQL_DAYS}" 2> /dev/null

# Count of days with settlements.
DAYS_COUNT=$(mysql --skip-column-names --user=${DB_USER} --password=${DB_PASSWD} --database=${DB} --execute="${SQL_DAYS_COUNT}" 2> /dev/null)

echo -e "\nDays in settlements table: ${DAYS_COUNT}\n"

# Only allow deletion when amount of days is greater than 2.
if [ ${DAYS_COUNT} -gt 2 ]
then
    FIRST_DAY=$(mysql --skip-column-names --user=${DB_USER} --password=${DB_PASSWD} --database=${DB} --execute="${SQL_FIRST_DAY}" 2> /dev/null)

    read -n 1 -p "Do you want to delete day ${FIRST_DAY}? [Y/n]"

    if [[ ! -z "${REPLY}" && ${REPLY} = "Y" ]]
    then
        echo -e "\n\nDay ${FIRST_DAY} deleted.\n"

        # Delete query.
        SQL_DELETE="delete from settlements where date = '${FIRST_DAY}';"
        mysql --user=${DB_USER} --password=${DB_PASSWD} --database=${DB} --execute="${SQL_DELETE}" 2> /dev/null

        # Show table with new amount of dates with settlements.
        mysql --user=${DB_USER} --password=${DB_PASSWD} --database=${DB} --execute="${SQL_DAYS}" 2> /dev/null
    else
        echo -e "\nOK no days deleted.\n"
    fi
fi

##END##
