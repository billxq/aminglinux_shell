#!/bin/bash

# 第二题：分析2.log中ip的访问量

ipcnt=`cat 2.log | awk -F- '{print $1}' | sort -n | uniq -c`
echo "$ipcnt\n"
