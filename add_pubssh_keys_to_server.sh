#!/bin/bash

# 提示输入ip，密码
read -p "Please input the ip address: " ip
ping -c 2 $ip &>/dev/null

while [ $? -ne 0 ];
do
    read -p "Your ip is not accessable. Please input again: " ip
    ping -c 2 $ip &>/dev/null
done

echo -ne "Input your password: "
stty -echo
read password
stty echo

# 检查命令函数
check_ok() {
    if [ $? -ne 0 ];then
        echo " $1 Error!"
        exit 1
    fi
}

# 安装包函数

myyum() {
    if ! rpm -qa | grep -q "$1";then
        yum -y install $1
        check_ok
    else
        echo "$1 has been installed!"
    fi
}


# 安装需要的依赖

for i in openssh-clients openssl expect;
do
    myyum $i
done


# 在主机A上创建私钥
if [ ! -f /root/.ssh/id_rsa ] || [ ! -f /root/.ssh/id_rsa.pub ];then
    if [ -d /root/.ssh ];then
        mv /root/.ssh /root/.ssh_old
    fi
    echo -e "\n" | ssh-keygen -t rsa -P
    check_ok keygen
fi

#  复制公钥到B
if [ ! -d /usr/local/sbin/rsync_keys ];then
    mkdir  /usr/local/sbin/rsync_keys
fi
cd  /usr/local/sbin/rsync_keys
if [ -f rsync.expect ];then
    d=`date +%F-%T`
    mv rsync.expect ${d}.expect
fi


# 创建远程同步的expect文件
cat > rsync.expect <<-EOF
#!/usr/bin/expect
set host [lindex \$argv 0]
set passwd [lindex \$argv 1]
spawn rsync -av /root/.ssh/id_rsa.pub root@\$host:/tmp/key.txt
expect {
    "yes/no" {send "yes\r";exp_continue;}
    "password:" {send "\$passwd\r";}
}
expect eof
spawn ssh root@\$host
expect {
    "yes/no" {send "yes\r";exp_continue;}
    "password:" {send "\$passwd\r";}
}
expect "]*"
send "\[ -f /root/.ssh/authorized.keys \] && cat /tmp/key.txt >> /root/.ssh/authorized_keys \r"
expect "]*"
send "\[ -f /root/.ssh/authorized.keys \] || mv /tmp/key.txt /root/.ssh/authorized_keys \r"
expect "]*"
send "chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys \r"
expect "]*"
send "exit\r"
EOF

check_ok EOF

/usr/bin/expect /usr/local/sbin/rsync_keys/rsync.expect $ip $password
check_ok exec_expect
echo "OK,job's done! ssh $ip to test!"
































