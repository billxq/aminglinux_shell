#!/bin/bash

# web服务器上，用户会上传新文件到/data/web/attachment目录下
# 要求每隔5分钟检查一次用户有没有上传新文件
# 如果有就把新文件列表输出到一个按年月日时分为名字的日志里

d=`date -d "-5 min"+"%Y%m%d%H%M"`  # date -d "-5 min" 表示5分钟以前的时间
att_dir=/data/web/attachment
cmd=`find $att_dir -type f -mmin 5`

$cmd > /tmp/newfile.txt
if [ `wc -l|/tmp/newfile.txt ` -gt 0 ];then
    /bin/mv /tmp/newfile.txt /tmp/$d
fi
