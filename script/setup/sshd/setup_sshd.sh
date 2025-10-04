#!/bin/bash

# setup /etc/ssh/sshd_sonfig 


echo "Port 2007
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no" >> /etc/ssh/sshd_config

