#!/bin/bash

source components/common.sh

COMPONENT=rabbitmq

echo -n "Configuring and Installing dependency:"

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
stat $?
# yum install curl gnupg apt-transport-https -y &>> ${LOGFILE}
# yum install -y erlang-base &>> ${LOGFILE}
# yum install https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh -y &>> ${LOGFILE} 
#curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash  &>> ${LOGFILE} 
 

echo -n "Installing RabbitMQ: "
yum install rabbitmq-server -y &>> ${LOGFILE} 
stat $? 

echo -n "Starting $COMPONENT :"
systemctl enable rabbitmq-server &>> ${LOGFILE} 
systemctl start rabbitmq-server &>> ${LOGFILE} 
stat $? 

rabbitmqctl list_users | grep roboshop  2>> ${LOGFILE} 
if [ $? -ne 0 ]; then 
    echo -n "Creating $COMPONENT Application user:" &>> ${LOGFILE} 
    rabbitmqctl add_user roboshop roboshop123 &>> ${LOGFILE} 
    stat $? 
fi 

echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE}  &&  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> ${LOGFILE} 
stat $? 

echo -e "\n ************ $Component Installation Completed ******************** \n"


