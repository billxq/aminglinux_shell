#!/bin/bash
# 统计网卡的流浪

[ -z `rpm -qa sysstat` ] && echo "sar命令包未安装";yum -y install sysstat >/dev/null




while true
do
    LANG=en
    d=`date +"%F %H:%M"`
    logdir="/tmp/sar"
    [ -d $logdir ] || mkdir $logdir
    logfile=$logdir/trafic_check_`date +%d`.log
    exec >> $logfile    # exec 指脚本接下来的输出将会写入到logfile这个文件中
    echo "$d"
    sar -n DEV 1 59 | grep Average | grep enp2s0 | awk '{print $2,"\t","input:",$5*8000bps,"\n",$2,"\t","output:",$6*8000bps}'
    echo "##############################"
done
    

