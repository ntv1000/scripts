#!/bin/bash

# Generates a config file from /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
