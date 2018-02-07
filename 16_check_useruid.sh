#!/bin/bash
# 查看系统中是否有普通用户，即uid大于500的用户（centos6）,centos7则大于1000
# 有的话就打印出来

n=`awk -F: '$3>=1000' /etc/passwd|wc -l`
if [ $n -gt 0 ];then
    echo "You have $n common users."
    echo "They are:"
    for i in `awk -F: '$3>=100 {print $1}' /etc/passwd`;do
        echo -e "\t$i"
    done
else
    echo "You have no common users."
fi
    
