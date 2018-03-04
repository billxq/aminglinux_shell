#!/bin/bash
# 小型计算器

# 判断传递参数是否为2个，参数个数用$#表示
if [ $# -ne 2 ];then
    echo "The number of the parameter is not 2. Please note the usage: ./$0 1 2"
    exit 1
fi

# 判断输入的是否为整数
is_int() {
    if echo "$1" | grep -q [^0-9];then
        echo "$1 is not an interger number!"
        exit 1
    fi
}

# 判断最大数字
max() {
    if [ $1 -ge $2 ];then
        echo $1
    else
        echo $2
    fi
}

# 判断最小
min() {
    if [ $1 -lt $2 ];then
        echo $1
    else
        echo $2
    fi
}

# 计算和
sum() {
    echo "$1 + $2 = $[$1+$2]"
}
# 计算差
minus() {
    big=`max $1 $2`
    small=`min $1 $2`
    echo "$big - $small = $[$big-$small]"
}

# 计算乘积
multi() {
    echo "$1 x $2 = $[$1*$2]"
}

# 计算除法，保留2位小数可以这样实现：a=10,b=3;echo "scale=2;$a/$b"|bc
div() {
    big=`max $1 $2`
    small=`min $1 $2`
    d=`echo "scale=2;$big/$small"|bc`
    echo "$big / $small = $d"
}

is_int $1
is_int $2
sum $1 $2
minus $1 $2
multi $1 $2
div $1 $2





















