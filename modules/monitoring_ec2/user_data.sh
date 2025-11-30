#!/bin/bash
set -xe

# Terraform will substitute ${wordpress_private_ip}.

############################
# Base packages & updates  #
############################
yum update -y
yum install -y wget tar amazon-linux-extras

#########################
# Install node_exporter #
#########################
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
tar -xzf node_exporter-1.8.1.linux-amd64.tar.gz
mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.8.1.linux-amd64*

cat > /etc/systemd/system/node_exporter.service << 'EON'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=nobody
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EON

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

#######################
# Install Prometheus  #
#######################
cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz
tar -xzf prometheus-2.55.1.linux-amd64.tar.gz
mv prometheus-2.55.1.linux-amd64 /opt/prometheus

# Prometheus user may already exist on rerun
useradd --no-create-home --shell /sbin/nologin prometheus || true

mkdir -p /etc/prometheus /var/lib/prometheus
cp /opt/prometheus/prometheus /usr/local/bin/
cp /opt/prometheus/promtool /usr/local/bin/
cp -r /opt/prometheus/consoles /opt/prometheus/console_libraries /etc/prometheus

cat > /etc/prometheus/prometheus.yml << EOP
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'monitoring-node'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'wordpress-node'
    static_configs:
      - targets: ['${wordpress_private_ip}:9100']

  - job_name: 'yace'
    static_configs:
      - targets: ['localhost:5000']
EOP

cat > /etc/systemd/system/prometheus.service << 'EOP2'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOP2

chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

######################
# Install Docker     #
######################
amazon-linux-extras install docker -y || yum install -y docker
systemctl enable docker
systemctl start docker

###############################
# Configure YACE via Docker   #
###############################
mkdir -p /etc/yace

cat > /etc/yace/config.yml << 'EOY'
apiVersion: v1alpha1
discovery:
  jobs:
    - type: "AWS/RDS"
      regions:
        - "us-east-1"
      metrics:
        - name: "CPUUtilization"
          statistics: ["Average"]
        - name: "DatabaseConnections"
          statistics: ["Average"]
        - name: "FreeStorageSpace"
          statistics: ["Average"]
        - name: "FreeableMemory"
          statistics: ["Average"]
        - name: "ReadLatency"
          statistics: ["Average"]
        - name: "WriteLatency"
          statistics: ["Average"]
EOY

# Make sure no stale container is running (idempotent)
docker rm -f yace || true

# Pull and run the exporter container
docker pull prometheuscommunity/yet-another-cloudwatch-exporter-linux-amd64:v0.62.1

docker run -d \
  --name yace \
  --restart unless-stopped \
  --network host \
  -v /etc/yace/config.yml:/etc/yace/config.yml:ro \
  prometheuscommunity/yet-another-cloudwatch-exporter-linux-amd64:v0.62.1 \
  --config.file=/etc/yace/config.yml \
  --listen-address=":5000"

######################
# Install Grafana    #
######################
cat > /etc/yum.repos.d/grafana.repo << 'EOG'
[grafana]
name=Grafana OSS
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOG

yum install -y grafana
systemctl enable grafana-server
systemctl start grafana-server

