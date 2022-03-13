#!/usr/bin/env bash
set -e
sudo apt-get update -y
sudo apt-get install -y \
  debhelper \
  sbuild \
  schroot \
  ubuntu-dev-tools/$(lsb_release -c -s)-backports \
  debian-archive-keyring \
  git-buildpackage
sudo adduser $USER sbuild