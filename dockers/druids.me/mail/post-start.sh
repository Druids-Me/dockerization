#!/bin/sh

docker exec -d druidsme_mail_1 bash -c "bash /docker/tmp/fix-hosts.sh"
