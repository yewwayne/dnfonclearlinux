#!/bin/bash

# install bundle containing dnf
swupd bundle-add package-utils
# copy the dnf.conf from this repo
cp -v --backup --suffix .old dnf.conf /etc/dnf/
