#!/bin/sh
"$DOCKER_CONSOLE_SCRIPT_PATH"/scripts/host/reset-tmp.sh
cp "$DOCKER_CONSOLE_SCRIPT_PATH"/scripts/dockers/* ./docker/tmp/
cp ../hostnames-dockers ./docker/tmp/hosts
../network-create.sh
