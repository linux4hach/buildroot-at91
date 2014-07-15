#! /bin/bash

echo "Deleting old rootfs in /mnt/tftpboot/rootfs"
rm -rf /mnt/tftpboot/rootfs/*

echo "Uncompressing rootfs to /mnt/tftpboot/rootfs" 
tar zxvf output/images/rootfs.tar.gz -C /mnt/tftpboot/rootfs 

echo "Changing permissions to nobody"
chown  -R nobody /mnt/tftpboot

echo "Changing the var/empty directory to have no permissions for group or all write"
chmod -R ag-w /mnt/tftpboot/rootfs/var/empty

