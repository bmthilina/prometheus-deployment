#!/bin/bash
WORK_DIR="/tmp/deploy-node-exporter_$(date +%s)"
mkdir $WORK_DIR
cd $WORK_DIR

# Add user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Install node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
tar -zxf node_exporter-0.15.2.linux-amd64.tar.gz
sudo cp node_exporter-0.15.2.linux-amd64/node_exporter /usr/local/bin/
sudo chmod u+x /usr/local/bin/node_exporter

# Install init scripts

# For systemd
if ps -ef | grep systemd | grep -v grep > /dev/null
then
	INIT_SCRIPT="/etc/systemd/system/node_exporter.service"
	INIT_SCRIPT_SRC="https://raw.githubusercontent.com/bmthilina/systemd-scripts/master/node_exporter.service"
	sudo curl $INIT_SCRIPT_SRC > $INIT_SCRIPT
	sudo systemctl daemon-reload
	sudo systemctl start node_exporter
	sudo systemctl status node_exporter

# For initd
else
	INIT_SCRIPT="/etc/init.d/node_exporter"
	INIT_SCRIPT_SRC="https://raw.githubusercontent.com/bmthilina/init-scripts/master/node_exporter"	
	sudo curl $INIT_SCRIPT_SRC > $INIT_SCRIPT
	sudo chmod u+x $INIT_SCRIPT
	sudo chkconfig --add node_exporter
	sudo service node_exporter start
fi