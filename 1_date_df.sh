#!/bin/bash
# 每日生成一个文件，格式：xxxx-xx-xx.log(如2018-02-05.log)，并把磁盘使用情况写入该文件中。

d=`date +%Y-%m-%d`

df -h > $d.log


#反引号通常用来表示命令的结果，用于给变量赋值，如d=`date +%F`(结果等同于date +%Y-%m-%d)

