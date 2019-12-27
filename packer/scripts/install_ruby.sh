#!/bin/bash
set -e
# Install ruby
apt --assume-yes update
apt --assume-yes install ruby-full ruby-bundler build-essential
