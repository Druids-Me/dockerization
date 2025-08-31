#!/bin/bash

docker network prune -f

net_count_test=`docker network ls  | grep ' dev_druidsme_net ' | wc -l`
if [ "$net_count_test" == "1" ]
then
  echo "NETWORK ALREADY EXISTS - dev_druidsme_net"
  exit
fi


docker network create --driver=bridge --subnet=172.16.5.0/24 --ip-range=172.16.5.0/24 --gateway=172.16.5.1 dev_druidsme_net
echo "NEW NETWORK CREATED - dev_druidsme_net"
