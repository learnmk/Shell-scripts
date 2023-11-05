#!/bin/bash

# Check if the script is being run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Update the system and install necessary packages
yum update -y
yum install httpd mariadb-server mariadb php php-mysql -y

# Start and enable Apache and MariaDB services
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb

# Secure the MariaDB installation (set root password, remove anonymous users, etc.)
mysql_secure_installation

# Create a sample PHP info page
echo -e "<?php\nphpinfo();\n?>" > /var/www/html/info.php

# Firewall rules for HTTP and HTTPS
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# Display information and next steps
echo "LAMP stack is installed and configured."
echo "You can access your web server at http://your_server_ip/"
echo "A PHP info page is available at http://your_server_ip/info.php"
