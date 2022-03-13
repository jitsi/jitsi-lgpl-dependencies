#!/usr/bin/env bash
set -e
set -x
sudo apt-get update -y
sudo apt-get install -y \
  debhelper \
  sbuild \
  schroot \
  ubuntu-dev-tools/$(lsb_release -c -s)-backports \
  python3-ubuntutools/$(lsb_release -c -s)-backports \
  debian-archive-keyring \
  git-buildpackage \
  rename
sudo adduser $USER sbuild
