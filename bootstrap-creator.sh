#!/usr/bin/env bash

cat >> ~/.ssh/authorized_keys
# TODO ./users.awk run="echo $REPLY >> .ssh/authorized_keys" /etc/hosts
cat ~/.ssh/id_ed25519.pub
