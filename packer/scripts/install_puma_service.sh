#!/usr/bin/env bash
set -e
# systemd puma.service
mv /home/appuser/puma.service /etc/systemd/system/
cd /etc/systemd/system
chown root:root puma.service
systemctl daemon-reload
systemctl enable puma.service
systemctl start puma.service
