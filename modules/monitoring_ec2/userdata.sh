#!/bin/bash

# Update system
yum update -y

##############################################
# Install Prometheus
##############################################

cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
tar -xzf prometheus-2.46.0.linux-amd64.tar.gz
mv prometheus-2.46.0.linux-amd64 prometheus

# Create Prometheus user
useradd --no-create-home --shell /sbin/nologin prometheus
chown -R prometheus:prometheus /opt/prometheus

# Create Prometheus systemd service
cat <<EOF >/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring
After=network.target

[Service]
User=prometheus
ExecStart=/opt/prometheus/prometheus \
    --config.file=/opt/prometheus/prometheus.yml \
    --storage.tsdb.path=/opt/prometheus/data

Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus


##############################################
# Install Node Exporter
##############################################

cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
tar -xzf node_exporter-1.6.0.linux-amd64.tar.gz
mv node_exporter-1.6.0.linux-amd64 node_exporter

# Create Node Exporter user
useradd --no-create-home --shell /sbin/nologin node_exporter
chown -R node_exporter:node_exporter /opt/node_exporter

# Create Node Exporter systemd service
cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/opt/node_exporter/node_exporter

Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter


##############################################
# Install Grafana
##############################################

cat <<EOF >/etc/yum.repos.d/grafana.repo
[grafana]
name=Grafana Repository
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
gpgcheck=1
enabled=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

yum install grafana -y

systemctl enable grafana-server
systemctl start grafana-server

