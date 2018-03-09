#!/bin/bash

# 去掉扩展名
for i in `ls /etc/yum.repos.d/`;do
    name=${i%.*}
    echo $name
done

# 提取扩展名

for i in `ls /etc/yum.repos.d/`;do
    name=${i#*.}
    echo $name
done

# 说明：%代表匹配位于%右侧的通配符，这里是.*,从右向左开始匹配
# #号代表从左向右开始匹配
# 原理： 从$i中删除位于%右侧通配符（这里是.*）所匹配的字符串
