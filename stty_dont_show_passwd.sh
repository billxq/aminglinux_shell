#!/bin/bash
# -echo 禁止将输出发送到终端，而选项echo则允许发送输出
echo -e "Enter password: "
stty -echo
read password
stty echo
echo
echo Password read.
