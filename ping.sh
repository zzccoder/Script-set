#!/bin/bash
#writen by Jerry
for i in $(seq 1 255);
   do
     {
        ping 192.168.51.$i -c 2 >> /dev/null 2>&1    #����ping��ping����������ǰ̨��ʾ
        tai=$(echo $?)
        if [ $tai == 0 ];
            then
                echo -e "\033[1;32m 192.168.51.$i is online \033[0m"    #������ɫ��ʾonline
            else
                echo -e "\033[1;35m 192.168.51.$i is offline \033[0m"    #ͬ��
        fi
        }&
   done
    wait
    echo "all Finished