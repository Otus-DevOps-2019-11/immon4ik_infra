#!/bin/bash
set -e
# systemd hw5.service
cp /tmp/hw5.service /etc/systemd/system/hw5.service
systemctl daemon-reload
systemctl enable hw5.service
