#!/bin/sh
sudo grub-reboot "$(grep -i 'windows' /boot/grub/grub.cfg|cut -d"'" -f2)" && \
    sudo reboot
