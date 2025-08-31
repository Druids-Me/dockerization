#!/bin/bash

if [ ! -e ./docker ]
then
  mkdir ./docker
fi

if [ -e ./docker/tmp ]
then
  rm -rf ./docker/tmp
fi
mkdir ./docker/tmp
