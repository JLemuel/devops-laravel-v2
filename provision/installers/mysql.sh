#!/bin/bash

# Install MySQL
sudo apt-get install -y mysql-server

# Start the MySQL service
sudo systemctl start mysql

# Set the root password
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$installs_database_root_password';"

echo "ROOT PASSWORD = $installs_database_root_password"

# Automate the mysql_secure_installation process
SECURE_MYSQL=$(expect -c "

set timeout 10
spawn sudo mysql_secure_installation

expect \"Enter password for user root:\"
send \"$installs_database_root_password\r\"

expect \"VALIDATE PASSWORD component?\"
send \"n\r\"

expect \"Change the password for root?\"
send \"n\r\"

expect \"Do you wish to continue with the password provided?\"
send \"y\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")
echo "$SECURE_MYSQL"

# Enable MySQL to start on boot
sudo systemctl enable mysql