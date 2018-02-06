#!/bin/bash

# Bash also interprets a number of multi-character options.
# 用shell打印上述这段话中字母数小于6的单词

for s in Bash also interprets a number of multi-character options;do
	n=`echo $s|wc -c`
	if [ $n -lt 6 ];then
		echo $s
	fi
done
