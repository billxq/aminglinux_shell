#!/bin/bash

# 计算100以内能被3整除的正整数之和

sum=0
i=1
while [ $i -lt 100 ];do
    if [ `expr $i % 3` -eq 0 ];then
        sum=$[$sum+$i]
    fi
    i=$[$i+1]
done

echo "100以内能被3整除的正整数之和是：$sum"
