mysqldump -uroot -pjjsc_1024Mysql  --single-transaction --master-data=2 --databases kshop > /home/kshop/backup/kshopdb_`date +%F`.sql
cd /home/kshop/backup
tar zcvf kshopdb_`date +%F`.tar.gz kshopdb_`date +%F`.sql
if [ -f kshopdb_`date +%F -d -1day`.sql ]; then
rm kshopdb_`date +%F -d -1day`.sql
fi
if [ -f kshopdb_`date +%F -d -10day`.tar.gz ]; then
rm kshopdb_`date +%F -d -10day`.tar.gz
fi



