#!/bin/bash

# 检测所有磁盘的使用率和inode使用率，并记录到以当天日期为名字的日志文件里
# 当发现某个分区容量或者inode使用量大于85%时，发邮件提醒自己
# 邮件脚本暂时以mail.py
# 思路：分四种情况：
# 1. 磁盘有问题，inode没问题，标记tag=1
# 2. 磁盘没问题，inode有问题，标记tag=2
# 3. 都没问题，标记tag=0
# 4. 都有问题，标记tag=3

d=$(date +%F)
log=/tmp/disk/$d.log
[ -d /tmp/disk ] || mkdir /tmp/disk
tag1=0
tag2=0
mail=123@qq.com


date +"%F-%T" >> $log
df -h >> $log
df -i >> $log

for i in `df -h | grep -v Use| awk -F ' +|%' '{print $5}'`
do
    if [ $i -gt 85 ];then
        tag1=1
    fi
done
for i in `df -i | grep -v Use| awk -F ' +|%' '{print $5}'`
do
    if [ $i -gt 85 ];then
        if [ tag1 -eq 1 ];then
            tag2=1
        fi
    fi
done

if [ $tag1 -eq 0 ];then
    if [ $tag2 -eq 0 ];then
        tag=0
    else
        tag=2
    fi
fi

if [ $tag1 -eq 1 ];then
    if [ $tag2 -eq 0 ];then
        tag=1
    else
        tag=3
    fi
fi


case $tag in
    1)
        python mail.py $mail "Disk space is not enough!" "`df -h`"
    ;;
    2)
        python mail.py $mail "Inode is not enough!" "`df -i`"
    ;;
    3)
        python mail.py $mail "Disk space and inode are not enough!" "`df -h`;`df -i`"
    ;;
    0)
        echo "Do nothing!"
    ;;
esac






























