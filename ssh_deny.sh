#!/bin/bash
# 该脚本用于防止那些暴力ssh登录的ip，将这些ip加入hosts.deny文件中
while :
do
    cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /root/black.txt
    DEFINE="5"
    for i in `cat  /root/black.txt`
    do
    　　IP=`echo $i |awk -F= '{print $1}'`
    　　NUM=`echo $i|awk -F= '{print $2}'`
    　　if [ $NUM -gt $DEFINE ];then
      　　grep $IP /etc/hosts.deny > /dev/null
          if [ $? -gt 0 ];then
              echo "sshd:$IP:deny" >> /etc/hosts.deny
          fi
        fi
    done
    sleep 60
done
