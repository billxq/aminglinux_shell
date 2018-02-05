#!/bin/bash
#计算所有进程占用内存大小的和。
# 本脚本运用ps aux命令统计内存大小，其中RSS表示物理内存集,进程战用实际物理内存空间

sum=0
for mem in `ps aux | awk '{print $6}'|grep -v RSS`;do
	sum=`expr $sum + $mem`
done
tot_mem=`expr $sum / 1024`
echo "系统进程占用内存大小的和为：$tot_mem MB."

