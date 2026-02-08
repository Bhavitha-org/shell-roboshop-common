#!/bin/bash

source ./common.sh
app_name=shipping

CHECK_ROOT
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "Installing mysql"


mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Loaded data into MySql"
else
    echo -e "Data already loaded...$Y SKIPPING $N"
fi

app_restart
print_total_time