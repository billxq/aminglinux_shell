#!/bin/bash

# 列出你最常用的100个命令

sort /root/.bash_history | uniq -c | sort -nr | head -n100
