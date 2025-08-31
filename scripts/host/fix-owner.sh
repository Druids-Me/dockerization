#!/bin/bash

if [ "$#" -eq 0 ]
then
  echo "[fix-owner.sh] - requires path"
  exit 1
fi

if [ ! -e "$1" ]
then
  echo "[fix-owner.sh] - path does not exists"
  exit 1
fi

echo "[fix-owner.sh] - Fixing file rights in '$1' - requires sudo access"
username=$(whoami)
sudo chown -R $username $1
sudo chmod -R a+rw $1
sudo -K
