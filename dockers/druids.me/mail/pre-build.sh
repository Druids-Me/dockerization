#!/bin/sh

# dev_repo=$(cat DEV_REPO)
# echo "[Fixing file rights in $dev_repo/storage] - requires sudo access"
# sudo chmod -R a+rw $dev_repo/storage/

# "$DOCKER_CONSOLE_SCRIPT_PATH"/scripts/host/fix-owner.sh ./var

"$DOCKER_CONSOLE_SCRIPT_PATH"/scripts/host/reset-tmp.sh
cp "$DOCKER_CONSOLE_SCRIPT_PATH"/scripts/dockers/* ./docker/tmp/
cp ../hostnames-dockers ./docker/tmp/hosts
../network-create.sh
