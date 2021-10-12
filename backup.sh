#!/bin/bash

echo "This script moves log file from a localhost to an S3 bucket."  

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
HOSTNAME=$(hostname)
CUSTOM=$(date +"%F")
LOG_LOCATION='/opt/app/arkcase/log'
LOG_FILE='$LOG_LOCATION/bactes-$HOSTNAME.tar.gz'
DEST_LOCATION='/sharecare-prod-s3fs/'


if [[ ! -d /opt/$YEAR ]] || [[ ! -d /opt/$YEAR/$MONTH ]]; then
    mkdir -p /opt/$YEAR;
    mkdir -p /opt/$YEAR/$MONTH;
fi;

mv  $LOG_LOCATION/bactes-$CUSTOM.log $LOG_LOCATION/bactes-$HOSTNAME.log

tar -czvf $LOG_LOCATION/bactes-$HOSTNAME.tar.gz $LOG_LOCATION/bactes-$HOSTNAME.log

rm -f $LOG_LOCATION/bactes-$HOSTNAME.log

if [ ! $LOG_FILE $DEST_LOCATION/$YEAR/$MONTH ]; then
    mv $LOG_FILE $DEST_LOCATION/$YEAR/$MONTH ;
fi;

chmod +x /root/log-test/backup.sh

crontab -e 0 1 * * * /root/log-test/backup.sh
