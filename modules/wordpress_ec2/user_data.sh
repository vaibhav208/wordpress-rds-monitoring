#!/bin/bash
set -xe

yum update -y
yum install -y httpd wget tar

systemctl enable httpd
systemctl start httpd

# Install PHP 8.1
amazon-linux-extras install -y php8.1
yum install -y php-mysqlnd

systemctl restart httpd

####################################
# Install & Configure Node Exporter
####################################
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.8.1.linux-amd64.tar.gz
mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.8.1.linux-amd64*

cat > /etc/systemd/system/node_exporter.service <<EOF2
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF2

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

####################################
# Install WordPress
####################################
cd /var/www/html
rm -f index.html

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_username}/" wp-config.php
sed -i "s/password_here/${db_password}/" wp-config.php
sed -i "s/localhost/${db_host}/" wp-config.php

chown -R apache:apache /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

systemctl restart httpd
