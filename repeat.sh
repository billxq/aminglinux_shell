#!/bin/bash
# 重复执行命令，直到成功；用到了$@代表参数的内容，而$#代表参数个数

repeat() {
    while :;do $@ && echo "success!";return;done
}

repeat $@
