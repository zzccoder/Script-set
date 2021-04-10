#!/bin/bash
#writen by Jerry
for i in $(seq 1 255);
   do
     {
        ping 192.168.51.$i -c 2 >> /dev/null 2>&1    #无论ping到ping不到都不在前台显示
        tai=$(echo $?)
        if [ $tai == 0 ];
            then
                echo -e "\033[1;32m 192.168.51.$i is online \033[0m"    #加重颜色显示online
            else
                echo -e "\033[1;35m 192.168.51.$i is offline \033[0m"    #同上
        fi
        }&
   done
    wait
    echo "all Finished