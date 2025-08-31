#!/bin/sh

cd /docker/tmp
cp /etc/hosts hosts-tmp

for i in `cat hosts | sed 's/#//g' | awk '{print $2}'`; do cp hosts-tmp hosts-tmpt; grep -v $i hosts-tmpt > hosts-tmp; done
echo >> hosts-tmp
echo "# DOCKERIZATION NETWORK" >> hosts-tmp
echo "# ---------------------" >> hosts-tmp

cat hosts >> hosts-tmp
cat hosts-tmp > /etc/hosts
rm hosts-tmp
