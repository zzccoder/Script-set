#!/bin/sh
 
#ɾ������·���µ��޸�ʱ����10����ǰ����־�ļ�
find $1 -mtime +10 -name "*log*" -exec rm -f {} \;

