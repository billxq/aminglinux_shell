#!/bin/bash
# 把/123目录下的.txt文件批量修改为.txt.bak
# 把这些.bak文件打包压缩为123.tar.gz
# 批量还原文件的名字，即把.bak去掉

cd /123
find ./ -type f -name "*.txt" > /123/txt.list
for n in `cat /123/txt.list`
do
	mv $n $n.bak
done

d=`date +%F`
mkdir -p /tmp/123_$d
cp /123/*.bak /tmp/123_$d/
tar czvf /123/123.tar.gz /tmp/123_$d/*

for i in `cat /123/txt.list`
do
	mv $i.bak $i
done
