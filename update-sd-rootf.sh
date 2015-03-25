#! /bin/bash

echo "Deleting old rootfs in /media/user/rootfs"
rm -rf /media/$1/rootfs/*

echo "Uncompressing rootfs to /media/user/rootfs" 
tar zxvf output/images/rootfs.tar.gz -C /media/$1/rootfs 


echo "Changing the var/empty directory to have no permissions for group or all write"
chmod -R ag-w /media/$1/rootfs/var/empty
chown -R root /media/$1/rootfs/var/empty

