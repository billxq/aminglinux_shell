#!/bin/bash
ps aux | awk '/[0-9]/ {print $2}' | while read pid
do
	result=`find  /proc -maxdepth 1 -type d -name "$pid"`
	if [ -z $result ];then
		echo "Warning! $pid abnormal!"
	fi
done
