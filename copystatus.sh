#!/bin/bash

##First find the pid of a CP
##remove matches of the grep process
PID=`ps ax | grep "cp" | grep "D+" | awk '{print $1}'`
TOTAL_BYTES=$(du -sb $(ps -o args -p $PID | grep cp | awk '{print $(NF-1)}') | awk '{print $1}')

doneness=0

if [ "$1" == "-h" ]
then
unit="B"
while [ $doneness -ne 100 ];

do
BYTES_WRITTEN=$( sudo grep "^write_bytes: " /proc/$PID/io | awk '{print $2}')
doneness=$(( ( $BYTES_WRITTEN * 100 ) / $TOTAL_BYTES ))

if [ $BYTES_WRITTEN > 10240 ]
then
BYTES_WRITTEN=$(( $BYTES_WRITTEN / 1024 ))
unit="KB"
fi

if [ $BYTES_WRITTEN > 10240 ]
then
BYTES_WRITTEN=$(( $BYTES_WRITTEN / 1024 ))
unit="MB"
fi

if [ $BYTES_WRITTEN > 10240 ]
then
BYTES_WRITTEN=$(( $BYTES_WRITTEN / 1024 ))
unit="GB"
fi

#if [ $BYTES_WRITTEN > 1024 ]
#then
#BYTES_WRITTEN=$(( $BYTES_WRITTEN / 1024 ))
#unit="TB"
#fi

echo -e "                                        \r\c"
echo -e "$BYTES_WRITTEN $unit copied  $doneness % done"
sleep 20
done

else

while [ $doneness -ne 100 ];

do
BYTES_WRITTEN_written=$( sudo grep "^write_bytes: " /proc/$PID/io | awk '{print $2}')
doneness=$((  ($BYTES_WRITTEN_written * 100) / $TOTAL_BYTES ))

echo -e "$BYTES_WRITTEN_written out of $TOTAL_BYTES   $doneness % done \r\c"
sleep 20
done

fi
