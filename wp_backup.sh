#!/bin/bash
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="site.$NOW.tar"
BACKUP_DIR="/home/maciejowski/backup"
WWW_DIR="/var/www/dcdevelopment"
DB1_USER="wordpress"
DB1_PASS="???"
DB1_NAME="wordpress"
DB1_FILE="dcdevelopment.$NOW.sql"
DB2_USER="projectpier"
DB2_PASS="???"
DB2_NAME="projectpier"
DB2_FILE="projectpier.$NOW.sql"
EMAIL="artur.maciejowski@domconsult.com"
ENCRYPTION_PASS="???"
WWW_TRANSFORM='s,^var/www,www,'
DB_TRANSFORM='s,^home/maciejowski/backup,database,'
tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
mysqldump -u$DB1_USER -p$DB1_PASS $DB1_NAME > $BACKUP_DIR/$DB1_FILE
# mysqldump -u$DB2_USER -p$DB2_PASS $DB2_NAME > $BACKUP_DIR/$DB2_FILE
tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB1_FILE
# tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB2_FILE
rm $BACKUP_DIR/$DB1_FILE
# rm $BACKUP_DIR/$DB2_FILE
gzip -9 $BACKUP_DIR/$FILE
openssl aes-256-cbc -salt -k $ENCRYPTION_PASS -in $BACKUP_DIR/$FILE.gz -out $BACKUP_DIR/$FILE.gz.enc
echo 'Backup attached' | mutt -a $BACKUP_DIR/$FILE.gz.enc $EMAIL -s "Wordpress Backup"
find $BACKUP_DIR -type f -mtime +7 -exec rm {} \;
find $BACKUP_DIR/*.gz -type f -exec rm {} \;