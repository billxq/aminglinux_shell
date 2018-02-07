#!/bin/bash
# 观察10，31，53，77，105，141
# 根据规律，打印后面10个数字

a=10
n=0
echo $a
for i in `seq 0 14`;do
    d=$((2**$i))
    a=`expr $a + 20 + $d`
    echo $a
done
