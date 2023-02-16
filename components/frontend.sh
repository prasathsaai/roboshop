#!/bin/bash
set -e   # ensure your script will stop if any of the instruction fails

source components/common.sh

echo -n "Installing Nginx: "
yum install nginx -y   >> /tmp/frontend.log 

systemctl enable nginx 

echo -n "Starting Nginx: "
systemctl start nginx 
stat $?

echo -n "Downloading the Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

cd /usr/share/nginx/html
rm -rf *
echo -n "Extracting the zip file:"
unzip -o /tmp/frontend.zip >> /tmp/frontend.log
stat $? 

mv frontend-main/* .
mv static/* .
echo -n "Performing Cleanup: "
rm -rf frontend-main README.md
stat  $?

echo -n "Configuring the Reverse Proxy: "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?


for component in catalogue user cart shipping payment; do 
    echo -n "Updating the proxy file"
    sed -i -e "/${component}/s/localhost/${component}.awsdevops.internal/"  /etc/nginx/default.d/roboshop.conf
    stat $?
done

echo -n "Starting Ngnix: "
systemctl restart nginx
stat $?

# source is a command to import a file and run it locally
