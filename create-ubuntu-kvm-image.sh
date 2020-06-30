#!/bin/sh

#sudo apt install osinfo-db-tools && \
#    wget https://releases.pagure.org/libosinfo/osinfo-db-20200529.tar.xz && \
#    osinfo-db-import -v  osinfo-db-20200529.tar.xz 


virt-install  \
  --name ubuntu-server-20.04 \
  --memory 4096 \
  --vcpus 2 \
  --disk path=/mnt/1tbSSD/libvirt/images/ubuntu-server-20.04.img,size=8 \
  --os-type linux \
  --os-variant ubuntu20.04 \
  --network network=default \
  --graphics vnc \
  --console pty,target_type=serial \
  --cdrom /mnt/1tbSSD/libvirt/boot/ubuntu-20.04-live-server-amd64.iso
#  --location 'http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/' \
#  --extra-args 'console=ttyS0,115200n8 serial'
