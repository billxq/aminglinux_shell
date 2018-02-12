#!/bin/bash
# 计算文档a.txt中每一行中出现的数字个数，并且要计算一下整个文档中一共出现了几个数字。
# a.txt的内容如下

n=`wc -l $1|awk '{print $1}'`
sum=0

for i in `seq 1 $n`;do
    line=`sed -n "$i"p a.txt`
    number=`echo -n $line|sed 's/[^0-9]//g'| wc -L`
    echo "$number"
    sum=`expr $number + $sum`
done
echo "sum:$sum"
