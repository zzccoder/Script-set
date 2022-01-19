#!/bin/bash
LOG=/tmp/Update_Passwd_`date "+%m%d%Y_%H_%M_%S"`.log
FILE=/etc/.java/.systemPrefs/com/netapp/occm/prefs.xml
mysqlpass=`cat $FILE | grep mysql.password |awk '{print $3}' | cut -f2 -d"=" | cut -f1 -d"/" | cut -f2 -d"\""`
DB=oncloud
val1=y
val2=n

if [ -f $LOG ];then
    rm $LOG
fi

echo
printf "Are you sure you want to reset the password for admin user? [Y / N]: "
read -r input1
declare -l str1=$input1
while [[ "$str1" != $val1 && "$str1" != $val2 ]];do
		echo -n "ERROR: Must Enter [Y / N]: "
		read str1
	done
if [ $str1 == y ];then
    echo
    echo "admin users:"
    echo
    mysql -N -s -uroot -p$mysqlpass $DB -e "select email from user where role_id=1 and public_id not like '%system%';" 2>/dev/null
    echo
    echo -n "Please enter user's email: "
	read input2
    declare -l str2=$input2
    while [ -z "$str2" ];do
		echo -n "Empty input. Please enter user's email: "
		read str2
	done

    RESULT_VARIABLE="$(mysql -uroot -p$mysqlpass -se "SELECT EXISTS(SELECT 1 FROM oncloud.user WHERE email = '$str2')")"
    if [ $RESULT_VARIABLE == 1 ];then
		echo
        echo "Going to reset password for user" $str2
		echo
        read -s -p "New password: " newPass
		declare -l str3=$newPass
		while [ -z "$str3" ];do
			echo
			read -s -p "Password must not be empty. Please enter new password: " str3
		done
        echo
        read -s -p "Re-enter new password: " newPass2
        echo
        while [[ "$str3" != "$newPass2" ]];do
            echo -n "ERROR: passwords do not match"
            echo
            read -s -p "New password: " newPass
			str3=$newPass
			while [ -z "$str3" ];do
				echo
				read -s -p "Password must not be empty. Please enter new password: " str3
			done
            echo
            read -s -p "Re-enter new password: " newPass2
            echo
        done
        newpasswd=`echo -n "$str3"| openssl sha1 -binary | base64`
        mysql -uroot -p$mysqlpass $DB -e "update user SET password='$newpasswd' WHERE email='$str2'" >> $LOG 2>&1
        if [ $? -eq 0 ]; then
			echo
            echo "Password for user $str2 updated successfully." | tee -a $LOG
        else
			echo
            echo "[Error]: Failed to update password" | tee -a $LOG
            exit 1
        fi
    else
        echo "User $str2 doesn't exist in DB"
        exit 1
    fi
fi

