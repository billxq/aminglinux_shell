#!/bin/bash
# 语法：
# awk 'BEGIN{ print "start" } pattern { commands } END{ print "end" }' file

# example1
echo -e "line1\nline2" | awk 'BEGIN{print "Start"}{print}END{print "END"}'

# 特殊变量
# NR： 表示记录数量，在执行过程中相当于当前行号
# NF： 表示字段数量，在执行过程中对应于当前行的字段数
# $0：表示这个变量执行过程中当前行的文本内容
# $1: 第一个字段
# $2: 第二个字段

# 1.
echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{print "line num:"NR",No of fields:"NF,"$0="$0,"$1="$1,"$2="$2,"$3="$3}'

# 2. 打印倒数第二个字段$(NF-1)
echo "libstoragemgmt:x:997:994:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin" | awk -F ':' '{print $(NF-1)}'
# 3. 统计行数
echo -e "libstoragemgmt:x:997:994:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin\nchrony:x:996:993::/var/lib/chrony:/sbin/nologin\nunbound:x:995:992:Unbound DNS resolver:/etc/unbound:/sbin/nologin" | awk 'END{print NR}'
# 4. 累加
seq 5 | awk 'BEGIN{sum=0;print "SUM:"}{print $1"+";sum=sum+$1}END{print "=="; print sum}'
