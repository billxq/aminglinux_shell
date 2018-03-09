#!/bin/bash

# xargs 可以单行变多行，多行变单行
awk -F ':' '{print $1}' /etc/passwd | xargs


# xargs 可以和find一起用，批量删除，为了防止误删，如hello world.txt，会被看成hello和world.txt两个文件，所以要加-0参数
# find . -type f -name "*.txt" -print0 | xargs -0 rm -f


