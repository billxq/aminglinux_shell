#!/bin/bash

# 每天00点同步备份照片文件夹picbackup
d=`date +%F`
echo $d >> /tmp/rsync.log
rsync -avL /mnt/myshare/sdc1/picbackup/ /mnt/myshare/sda3/picbackup/ 1>>/tmp/rsync.log 2>&1
echo >> /tmp/rsync.log
[ $? -eq 0 ] && exit
    
