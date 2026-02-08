#!/bin/bash

source ./common.sh

app_name=frontend
APP_DIR=/usr/share/nginx/html #home dir for frontend, /app-> is the home dir for backend components
CHECK_ROOT

nf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx 
VALIDATE $? "Enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Downloading and unzipped frontend code"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx 
VALIDATE $? "Restarted nginx"

print_total_time