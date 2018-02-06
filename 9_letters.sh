#!/bin/bash

# 把1-5行中包含字母的行去掉
# 同时把6-10行中的所有字母去掉

# 我先自己创建了一个文件在/tmp/letter.txt下，以作测试

sed -n '1,5p' /tmp/letter.txt | sed '/[a-zA-Z]/d'
sed -n '6,10p' /tmp/letter.txt | sed 's/[a-zA-Z]//g'
sed -n '1,$p' /tmp/letter.txt
