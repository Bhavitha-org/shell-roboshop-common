#!/bin/bash

source ./common.sh

app_name=mysql
CHECK_ROOT

dnf install mysql-server -y
VALIDATE $? "Installing mysql server"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? "Enabled and Started mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"

print_total_time