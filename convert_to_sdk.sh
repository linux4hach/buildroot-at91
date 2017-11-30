#! /bin/bash
echo "Converting buildroot into a bare sdk for downloading"
name_of_dir=$(pwd)
cd $name_of_dir 
rm -rf fs arch board boot configs dl docs linux package support system toolchain utils sdcard
rm *
cd $name_of_dir/output
rm -rf build images staging target
echo "Conversion to sdk is complete"


