#!/bin/bash -x

#free -g
RAMDISK_SIZE=8
RAMDISK_DIR=/mnt/ramdisk
MOUNT_DIR_ENCRYPTED_CONTAINER=/mnt/encrypted_container

if cat /proc/mounts | grep -q ${MOUNT_DIR_ENCRYPTED_CONTAINER} ; then
	echo "${MOUNT_DIR_ENCRYPTED_CONTAINER} is already mounted"
	exit 1
fi
if cat /proc/mounts | grep -q ${RAMDISK_DIR} ; then
	echo "${RAMDISK_DIR} is already mounted"
	exit 1
fi

if [[ "$1" == "umount" ]]; then
	umount ${MOUNT_DIR_ENCRYPTED_CONTAINER}/
	cryptsetup remove ENCRYPTED_CONTAINER
	losetup  --detach /dev/loop101
	umount ${RAMDISK_DIR}
fi

set -e

mkdir -p ${RAMDISK_DIR}
mkdir -p ${MOUNT_DIR_ENCRYPTED_CONTAINER}

mount -t tmpfs -o size=${RAMDISK_SIZE}g tmpfs ${RAMDISK_DIR}
cd ${RAMDISK_DIR} || exit 1

# create ramdisk
time dd if=/dev/urandom of=container.aes bs=1073741824 count=${RAMDISK_SIZE} # 386mb/s ~= 1m6s

# create encrypted container
losetup /dev/loop101 ${RAMDISK_DIR}/container.aes 
ramdom_key=$(openssl rand -base64 32)
echo ${ramdom_key} | cryptsetup create ENCRYPTED_CONTAINER /dev/loop101 
mkfs.ext4 /dev/mapper/ENCRYPTED_CONTAINER 

# mount container
mkdir -p ${MOUNT_DIR_ENCRYPTED_CONTAINER}
mount  /dev/mapper/ENCRYPTED_CONTAINER  ${MOUNT_DIR_ENCRYPTED_CONTAINER}
chmod 700 ${MOUNT_DIR_ENCRYPTED_CONTAINER}
chown ${USER}. ${MOUNT_DIR_ENCRYPTED_CONTAINER}

cd ${MOUNT_DIR_ENCRYPTED_CONTAINER}
echo "Encrypted container was successfully mounted under ${MOUNT_DIR_ENCRYPTED_CONTAINER}"
