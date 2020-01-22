#!/bin/bash
gcloud compute instances create reddit-app-hw5\
  --boot-disk-size=10GB \
  --image-family reddit-full \
  --image-project=silken-period-262510 \
  --machine-type=g1-small \
  --tags ss-puma-server \
  --restart-on-failure
