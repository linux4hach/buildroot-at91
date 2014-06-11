#!/bin/bash
rm -rf output/build/linux-linux*
rm dl/linux-linux*
echo "Deleted kernel and reinstalling"
make

