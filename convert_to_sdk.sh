#! /bin/bash
echo "Converting buildroot into a bare sdk for downloading"
current_dir=$(pwd)
cd $current_dir 
rm -rf fs arch board boot configs dl docs linux package support system toolchain utils sdcard
rm *
cd $current_dir/output
rm -rf build images staging target
echo "Conversion to sdk is complete"


