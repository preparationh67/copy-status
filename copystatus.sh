#!/bin/sh
doneness=0
while [ $doneness -ne 100 ];

do
bytes=$( sudo grep "^write_bytes: " /proc/3630/io | awk '{print $2}') 
doneness=$(expr $bytes / 1024 / 1024 / 1024 \* 100 / 4500)

echo  "                                        \r\c"
echo  "$bytes bytes copied  $doneness % done \r\c"
sleep 20
done
