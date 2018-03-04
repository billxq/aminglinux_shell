#!/bin/bash

# 让用户输入数值，并打印，如果用户输入end，则退出
# sed 's/[0-9]//g' 会把所有数字删除，只留下非数字的字符，wc -L 会计算字符串长度，长度0 说明是纯数字，否则会含有非数字字符，
# 不符合要求

is_int() {
    if echo "$1" | grep -q [^0-9];then
        echo "$1 is not an interger number!"
        continue
    fi
}


while :
do
    read -p "请输入数值，如退出请输入(end): " n
    if [ $n == "end" ];then
        exit
    fi
    is_int $n
    echo "$n"
done
