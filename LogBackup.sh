LogBackup.sh--压缩前2天日志，备份前一天日志，重启nginx，我用corn每天定时 00:04分执行 
logs_path="/var/www/nginxLog/" 
date_dir=${logs_path}$(date -d "-1 day" +"%Y")/$(date -d "-1 day" +"%m")/$(date -d "-1 day" +"%d")/ 
gzip_date_dir=${logs_path}$(date -d "-2 day" +"%Y")/$(date -d "-2 day" +"%m")/$(date -d "-2 day" +"%d")/

mkdir -p ${date_dir} 
mv ${logs_path}*.log ${date_dir} 
kill -hup 'cat /var/www/nginxLog/nginx.pid' 
/usr/bin/gzip ${gzip_date_dir}*.log 