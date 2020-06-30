#!/bin/bash

sudo apt-get install qemu-kvm libvirt-bin bridge-utils virt-manager virt-viewer
sudo adduser $USER libvirtd
sudo adduser $USER libvirt
virsh -c qemu:///system list && echo OK


