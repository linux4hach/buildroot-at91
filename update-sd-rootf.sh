#! /bin/bash

echo "Deleting old rootfs in /media/ryang/rootfs"
rm -rf /media/ryang/rootfs/*

echo "Uncompressing rootfs to /media/ryang/rootfs" 
tar zxvf output/images/rootfs.tar.gz -C /media/ryang/rootfs 


echo "Changing the var/empty directory to have no permissions for group or all write"
chmod -R ag-w /media/ryang/rootfs/var/empty
chown -R root /media/ryang/rootfs/var/empty

