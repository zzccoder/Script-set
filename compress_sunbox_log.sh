#!/bin/bash

filepath="/home/sunbox/log"
cd $filepath
#取前5天的日志压缩
logdate=`date -d -5day +%Y-%m-%d`

files=$(ls $filepath | grep app-service.log.$logdate)

for filename in $files
do
	file_extend=${filename##*.}
	if [ "$file_extend" == "$logdate" ]; then

		echo "$(date "+%Y-%m-%d %H:%M:%S") compress $filename start" >> compress.log
		#tar -zcvf ./$filename.tar.gz ./$filename  >> compress.log
		#gzip -vc ./$filename > ./$filename.gz
		gzip ./$filename
		echo "$(date "+%Y-%m-%d %H:%M:%S") compress $filename done" >> compress.log
	fi
done
