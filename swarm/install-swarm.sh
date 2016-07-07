#!/usr/bin/env bash
set -e
wget -qO- https://test.docker.com/ | sh
sudo usermod -aG docker ubuntu