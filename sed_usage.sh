#!/bin/bash
# sed的一些用法

# 替换文本字符串

echo "this is a text about the usage of sed!" | sed -r 's/[a-z]/\u&/g'  # \u是把下一个元字符转换成大写，而&指的是之前所匹配到的字符


echo "this is a text about the usage of sed!" | sed -r 's/\b[a-z]/\u&/g'  # 这里的\b是指边界符

# /g表示匹配全部，/Ng表示匹配替换从第N处开始
echo "this is a text about the usage of sed!" | sed -r 's/\b[a-z]/\u&/2g'  # 从第二处开始

# -i选项修改文件内容，但最好不要先带这个选项，当确保没有问题后再加入-i选项，还以直接用-i.bak这种形式，这么做sed不仅执行文件内容的替换，还会创建一个包含原始文件内容的副本

# 删除空白行
# sed '/^$/d' file

# 复杂例子
# &
echo "11 abc 111 this 9 file contains 111 11 88 numbers 000" | sed -r 's/\b[0-9]{3}/[&]/g'

# \1
echo "this is digit 7 in a number" | sed -r 's/\bdigit ([0-9])/\1/' # \1指的是匹配括号里第一个子串的内容，如果是第二个子串就是\2

echo "seven EIGHT" | sed -r 's/([a-z]+) ([A-Z]+)/\2 \1/'




