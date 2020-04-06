#!/bin/bash
set -e
# Install MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
apt --assume-yes update
apt --assume-yes install mongodb-org
rm /etc/mongod.conf
mv /tmp/mongod.conf /etc/
chown root:root /etc/mongod.conf
systemctl daemon-reload
systemctl start mongod
systemctl enable mongod
