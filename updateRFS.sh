#! /bin/bash

echo "Deleting old rootfs in /server/tftpboot/rootfs"
rm -rf /srv/tftpboot/rootfs/*

echo "Uncompressing rootfs to /server/tftpboot/rootfs" 
tar zxvf output/images/rootfs.tar.gz -C /server/tftpboot/rootfs 

echo "Changing permissions to nobody"
chown  -R nobody /srv/tftpboot

echo "Changing the var/empty directory to have no permissions for group or all write"
chmod -R ag-w /srv/tftpboot/rootfs/var/empty
chown -R root /srv/tftpboot/rootfs/var/empty

