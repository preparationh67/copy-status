#!/bin/bash

##First find the pid of a CP
##remove matches of the grep process
##TODO: Will fail if cp is sleeping, please revise.
PID=""
COUNT=0
while [ -z $PID ];
do
PID=`ps ax | grep "cp" | grep "D+" | awk '{print $1}'`

###Try 6 times before failing
if [ "$COUNT" -eq 6 ]
then
echo CP pid not found!
exit 1
fi

COUNT=$(($COUNT+1))
sleep 1
done

TOTAL_BYTES=$(du -sb $(ps -o args -p $PID | grep cp | awk '{print $(NF-1)}') | awk '{print $1}')

doneness=0
REFRESH_SECONDS=20

##byte by default
unit="B"


if [ "$1" == "--help" ]
then
echo "./copystatus.sh [-h] [-t seconds]"
exit 1
fi

if [ "$1" == "-t" ]
then
REFRESH_SECONDS=$2
fi
if [ "$2" == "-t" ]
then
REFRESH_SECONDS=$3
fi


###Check if Human readable flag is set
if [ "$1" == "-h" ] || [ "$3" == "-h" ];
then

###Begin loop
while [ $doneness -ne 100 ];
do
BYTES_WRITTEN=$( sudo grep "^write_bytes: " /proc/$PID/io | awk '{print $2}')
doneness=$(( ( $BYTES_WRITTEN * 100 ) / $TOTAL_BYTES ))

##Bash does integer division so only if larger by a few factors do we devide for some granularity

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

echo -e "                                        \r\c"
echo -e "$BYTES_WRITTEN $unit copied  $doneness % done \r\c"
sleep $REFRESH_SECONDS

###END loop
done


else


while [ $doneness -ne 100 ];

do
	BYTES_WRITTEN=$( sudo grep "^write_bytes: " /proc/$PID/io | awk '{print $2}')
	doneness=$((  ($BYTES_WRITTEN * 100) / $TOTAL_BYTES ))

	echo -e "$BYTES_WRITTEN out of $TOTAL_BYTES   $doneness % done \r\c"
	sleep $REFRESH_SECONDS
done

fi

echo -e "\nDone\n"
