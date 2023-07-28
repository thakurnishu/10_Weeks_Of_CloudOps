#!/bin/bash

# Installing MYSQL mysql-server

echo "-------------------------------------------"
echo "|         Installing MySQL Server         |"
echo "-------------------------------------------"

sudo apt update -y
sudo apt install mysql-server -y


echo "-------------------------------------------"
echo "|      Running Database Setup Script      |"
echo "-------------------------------------------"
mysql -h <Database Hostname> -u <Admin User> -p < db_setup.sql


echo "-------------------------------------------"
echo "|            Installing Nodejs            |"
echo "-------------------------------------------"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install 16 && nvm use 16
npm install -g pm2   


echo "-------------------------------------------"
echo "|           Starting Application          |"
echo "-------------------------------------------"

cd application-code/app-tier
npm install
pm2 start index.js
startup_as_process=$(pm2 startup | grep -o 'sudo env.*')
eval "$startup_as_process"
pm2 save


echo "-------------------------------------------"
echo "|           Testing Application          |"
echo "-------------------------------------------"

echo "| http://localhost:4000/health check endpoint for application health |"
curl http://localhost:4000/health
echo "Check if above matches: 'This is the health check'"


echo "| http://localhost:4000/transaction check point for database health |"
curl http://localhost:4000/transaction

echo "---------------------------------------------------------------------------"
echo "|           Now you can Create Image out of this Virtual machine          |"
echo "---------------------------------------------------------------------------"

