#!/bin/sh

DIR=$(mktemp -d ${TMPDIR:-/tmp}/dockerdl.XXXXXXX) && \
curl -f -o $DIR/ld.tgz https://get.docker.io/builds/Darwin/x86_64/docker-latest.tgz && \
gunzip $DIR/ld.tgz && \
tar xvf $DIR/ld.tar -C $DIR/ && \
sudo cp $DIR/usr/local/bin/docker /usr/local/bin/
