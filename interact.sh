#!/bin/bash
echo -n "Please input a number: "
read num
echo  -n "Please input your name: "
read name
echo "You have entered $num,$name"



## echo -n 不要在最后自动换行；echo -e 允许特殊字符，如下：
#\a 发出警告声；
#\b 删除前一个字符；
#\c 最后不加上换行符号；
#\f 换行但光标仍旧停留在原来的位置；
#\n 换行且光标移至行首；
#\r 光标移至行首，但不换行；
#\t 插入tab；
#\v 与\f相同；
#\\ 插入\字符；
