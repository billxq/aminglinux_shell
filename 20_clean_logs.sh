#!/bin/bash

# 每天00点和12点清空/data/log目录下的全部日志文件，即清空内容，不删除文件
# 其余时间统计每个文件的大小，一个文件一行，输出到一个按照日期和时间为名字的日志里
# 需要考虑/data/log下的二级，三级...子目录里的日志文件

logdir="/data/log"
t=`date +%H`
d=`date +"%F-%H"`

[ -d /tmp/log_size ] || mkdir /tmp/log_size


for i in `find $logdir -type f`:
do
    if [ $t == "0" ] -o [ $t == 12 ];then
        true > $i
    else
        du -sh $i >> /tmp/log_size/$d
    fi
done
    
