#! /bin/bash

echo "Deleting old rootfs in /server/tftpboot/rootfs"
rm -rf /server/tftpboot/rootfs/*

echo "Uncompressing rootfs to /server/tftpboot/rootfs" 
tar zxvf output/images/rootfs.tar.gz -C /server/tftpboot/rootfs 

echo "Changing permissions to nobody"
chown  -R nobody /server/tftpboot

echo "Changing the var/empty directory to have no permissions for group or all write"
chmod -R ag-w /server/tftpboot/rootfs/var/empty
chown -R root /server/tftpboot/rootfs/var/empty
