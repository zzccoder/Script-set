#!/bin/sh
 
#删除输入路径下的修改时间在10天以前的日志文件
find $1 -mtime +10 -name "*log*" -exec rm -f {} \;

