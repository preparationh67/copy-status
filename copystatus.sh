#!/bin/bash

doneness=0

if [ "$1" == "-h" ]
then
unit="B"
while [ $doneness -ne 100 ];

do
bytes=$( sudo grep "^write_bytes: " /proc/3630/io | awk '{print $2}')
doneness=$(expr $bytes / 1024 / 1024 / 1024 \* 100 / 4500)

if [ $bytes > 10240 ]
then
bytes=$(expr $bytes / 1024)
unit="KB"
fi

if [ $bytes > 10240 ]
then
bytes=$(expr $bytes / 1024)
unit="MB"
fi

if [ $bytes > 10240 ]
then
bytes=$(expr $bytes / 1024)
unit="GB"
fi

#if [ $bytes > 1024 ]
#then
#bytes=$(expr $bytes / 1024)
#unit="TB"
#fi

echo -e "                                        \r\c"
echo -e "$bytes $unit copied  \r\c"
sleep 20
done

else

while [ $doneness -ne 100 ];

do
bytes=$( sudo grep "^write_bytes: " /proc/3630/io | awk '{print $2}')
doneness=$(expr $bytes / 1024 / 1024 / 1024 \* 100 / 4500)

echo  "                                        \r\c"
echo  "$bytes bytes copied  $doneness % done \r\c"
sleep 20
done

fi
